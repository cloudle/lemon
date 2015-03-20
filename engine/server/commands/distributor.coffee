Meteor.methods
  calculateDistributor: (id)->
    if distributor = Schema.distributors.findOne(id)
      distributorOption =
        customImportPaid      : 0
        customImportLoan      : 0
        customImportDebt      : 0
        customImportTotalCash : 0
        importPaid            : 0
        importDebt            : 0
        importTotalCash       : 0

      tempBeforeDebtBalance = 0
      Schema.customImports.find({seller: distributor._id}, {sort: {'version.createdAt': 1}}).forEach(
        (customImport) ->
          distributorOption.customImportDebt += customImport.debtBalanceChange
          distributorOption.customImportTotalCash += customImport.debtBalanceChange

          Schema.customImports.update customImport._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + customImport.debtBalanceChange
          }
          tempBeforeDebtBalance += customImport.debtBalanceChange

          Schema.transactions.find({latestImport: customImport._id}).forEach(
            (transaction) ->
              if transaction.debtBalanceChange > 0
                distributorOption.customImportPaid += transaction.debtBalanceChange
                distributorOption.customImportDebt -= transaction.debtBalanceChange
              else
                distributorOption.customImportDebt      -= transaction.debtBalanceChange
                distributorOption.customImportLoan      -= transaction.debtBalanceChange
                distributorOption.customImportTotalCash -= transaction.debtBalanceChange

              Schema.transactions.update transaction._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - transaction.debtBalanceChange
              }
              tempBeforeDebtBalance -= transaction.debtBalanceChange
          )
      )

      tempBeforeDebtBalance = 0
      Schema.imports.find({distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': 1}}).forEach(
        (currentImport) ->
          distributorOption.importDebt      += currentImport.debtBalanceChange
          distributorOption.importTotalCash += currentImport.debtBalanceChange
          Schema.imports.update currentImport._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + currentImport.debtBalanceChange
          }
          tempBeforeDebtBalance += currentImport.debtBalanceChange

          transactions = Schema.transactions.find({latestImport: currentImport._id}).fetch()
          returns = Schema.returns.find({timeLineImport: currentImport._id, status: 2}).fetch()
          dependsData = _.sortBy transactions.concat(returns), (item) -> item.version.createdAt
          for data in dependsData
            if data.latestImport
              if data.debtBalanceChange > 0
                distributorOption.importPaid += data.debtBalanceChange
                distributorOption.importDebt -= data.debtBalanceChange
              else
                distributorOption.importDebt      += data.debtBalanceChange
                distributorOption.importTotalCash += data.debtBalanceChange

              #cập nhật phiếu công nợ
              Schema.transactions.update data._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - data.debtBalanceChange
              }
              tempBeforeDebtBalance -= data.debtBalanceChange

            else
              distributorOption.importDebt      -= data.debtBalanceChange
              distributorOption.importTotalCash -= data.debtBalanceChange

              #cập nhật phiếu trả hàng
              Schema.returns.update data._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - data.debtBalanceChange
              }
              tempBeforeDebtBalance -= data.debtBalanceChange
      )

      Schema.distributors.update distributor._id, $set: distributorOption

  distributorToImport : (distributor, profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      if distributor.parentMerchant != profile.parentMerchant
        distributor = Schema.distributors.findOne({_id: distributor._id ,parentMerchant: profile.parentMerchant})

      if distributor
        importFound = Schema.imports.findOne({
          creator: userId
          distributor: distributor._id
          merchant: profile.currentMerchant
          finish: false
        }, {sort: {'version.createdAt': -1}})
        if !importFound then importFound = Import.createdNewBy(null, distributor, null, profile)
        Schema.userSessions.update {user: userId}, {$set:{'currentImport': importFound._id}}

      else throw 'Không tìm thấy nhà cung cấp'
    catch error
      throw new Meteor.Error('distributorToImport', error)


  distributorToReturns : (distributor, profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      if distributor.parentMerchant != profile.parentMerchant
        distributor = Schema.distributors.findOne({_id: distributor._id ,parentMerchant: profile.parentMerchant})

      if distributor
        returnFound = Schema.returns.findOne({
          merchant     : profile.currentMerchant
          creator      : userId
          distributor  : distributor._id
          status       : 0
          returnMethods: 1
        }, {sort: {'version.createdAt': -1}})
        if !returnFound then returnFound = Return.createByDistributor(distributor, profile)
        Schema.userSessions.update {user: userId}, {$set:{currentDistributorReturn: returnFound._id}} if returnFound
      else throw 'Không tìm thấy nhà cung cấp'

    catch error
      throw new Meteor.Error('distributorToReturns', error)

  distributorManagementDeleteImport: (importId)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()}); if !profile then throw 'Không tìm thấy profile'
      currentImport = Schema.imports.findOne(importId); if !currentImport then throw 'Không tìm thấy import'
      if Schema.returns.find({timeLineImport: currentImport._id}).count() > 0 then throw 'Đã trả hàng không thể xóa'

      productDetails = Schema.productDetails.find({import: currentImport._id}).fetch()
      for productDetail in productDetails
        if productDetail.importQuality != productDetail.availableQuality or productDetail.importQuality !=  productDetail.inStockQuality
          throw 'Đã bán hàng khong thể xóa'

      if productDetails.length > 0
        debtBalanceChange = currentImport.debtBalanceChange
        distributorIncOption = {importPaid: 0, importDebt: -debtBalanceChange, importTotalCash: -debtBalanceChange}
      else
        distributorIncOption = {importPaid: 0, importDebt: 0, importTotalCash: 0}



      Schema.transactions.find({latestImport: currentImport._id}).forEach(
        (transaction) ->
          if transaction.debtBalanceChange > 0
            distributorIncOption.importPaid += -transaction.debtBalanceChange
            distributorIncOption.importDebt += transaction.debtBalanceChange
          else
            distributorIncOption.importDebt += transaction.debtBalanceChange
            distributorIncOption.importTotalCash += transaction.debtBalanceChange

          Schema.transactions.remove transaction._id
      )

      for productDetail in productDetails
        optionInc =
          totalQuality      : -productDetail.importQuality
          availableQuality  : -productDetail.importQuality
          inStockQuality    : -productDetail.importQuality
        Schema.productDetails.remove productDetail._id
        Schema.products.update productDetail.product, $inc: optionInc
        Schema.branchProductSummaries.update productDetail.branchProduct, $inc: optionInc

      MetroSummary.updateMyMetroSummaryBy(['deleteImport'],  currentImport._id)
      Schema.imports.remove currentImport._id
      Schema.importDetails.find({import: currentImport._id}).forEach((detail)-> Schema.importDetails.remove detail._id)

      Schema.distributors.update currentImport.distributor, $inc: distributorIncOption
      Meteor.call 'updateMetroSummaryBy', 'deleteImport', currentImport._id, currentImport.merchant
    catch error
      throw new Meteor.Error('deleteTransaction', error)


  distributorManagementDeleteTransaction: (transactionId)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()}); if !profile then throw 'Không tìm thấy profile'
      currentTransaction = Schema.transactions.findOne(transactionId); if !currentTransaction then throw 'Không tìm thấy Transaction'
      validDateTransaction = new Date(currentTransaction.debtDate.getFullYear(),
        currentTransaction.debtDate.getMonth(),
        currentTransaction.debtDate.getDate() + 1,
        currentTransaction.debtDate.getHours(),
        currentTransaction.debtDate.getMinutes(),
        currentTransaction.debtDate.getSeconds()
        ); if validDateTransaction < new Date() then throw 'Transaction đã quá 24h.'
      currentImport = Schema.imports.findOne(currentTransaction.latestImport); if !currentImport then throw 'Không tìm thấy Import.'

      distributorIncOption =
        importPaid: 0
        importDebt: 0
        importTotalCash: 0

      if currentTransaction.debtBalanceChange > 0
        distributorIncOption.importPaid = -currentTransaction.debtBalanceChange
        distributorIncOption.importDebt = currentTransaction.debtBalanceChange
      else
        distributorIncOption.importDebt = currentTransaction.debtBalanceChange
        distributorIncOption.importTotalCash = currentTransaction.debtBalanceChange
      Schema.transactions.remove currentTransaction._id
      if currentImport.debtBalanceChange is 0 and Schema.transactions.find(latestImport: currentImport._id).count() is 0 then Schema.imports.remove currentImport._id

      tempBeforeDebtBalance = currentImport.beforeDebtBalance
      Schema.imports.find({distributor: currentImport.distributor, 'version.createdAt': {$gte: currentImport.version.createdAt} }
      , {sort: {'version.createdAt': 1}}).forEach(
        (myImport) ->
          Schema.imports.update myImport._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + myImport.debtBalanceChange
          }
          tempBeforeDebtBalance += myImport.debtBalanceChange

          transactions = Schema.transactions.find({latestImport: myImport._id}).fetch()
          returns      = Schema.returns.find({timeLineImport: myImport._id}).fetch()
          dependsData = _.sortBy transactions.concat(returns), (item) -> item.version.createdAt

          for data in dependsData
            optionSet =
              beforeDebtBalance: tempBeforeDebtBalance
              latestDebtBalance: tempBeforeDebtBalance - data.debtBalanceChange

            if data.latestImport then Schema.transactions.update data._id, $set: optionSet
            else Schema.returns.update data._id, $set: optionSet

            tempBeforeDebtBalance -= data.debtBalanceChange
      )

      Schema.distributors.update currentImport.distributor, $inc: distributorIncOption
    catch error
      throw new Meteor.Error('deleteTransaction', error)

