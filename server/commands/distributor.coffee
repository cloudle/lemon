Meteor.methods
  updateDistributorDebitAndSale: ->
    for distributor in Schema.distributors.find({}).fetch()
      setOption = {totalSales: 0,  totalDebit: 0}
      Schema.distributors.update distributor._id, $set: setOption

    for transaction in Schema.transactions.find({group: {$in:['import', 'distributor']} , receivable: false}).fetch()
      setOption = {allowDelete: false}
      incOption = {totalSales: transaction.totalCash,  totalDebit: transaction.debitCash}
      Schema.distributors.update transaction.owner, $set: setOption, $inc: incOption

  calculateDistributor: (id)->
    if distributor = Schema.distributors.findOne(id)
      distributorOption =
        customImportPaid : 0
        customImportLoan : 0
        customImportDebt : 0
        customImportTotalCash : 0
#        importPaid      : 0
#        importDebt      : 0
#        importTotalCash : 0

      Schema.customImports.find({seller: distributor._id}).forEach(
        (customImport)->
          distributorOption.customImportTotalCash += customImport.debtBalanceChange
          distributorOption.customImportDebt += customImport.debtBalanceChange
      )

#      Schema.transactions.find({owner: distributor._id}).forEach(
#        (transaction)->
#          distributorOption.customImportPaid += transaction.debtBalanceChange
#          distributorOption.customImportDebt -= transaction.debtBalanceChange
#      )
      console.log distributorOption

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
        if !importFound then importFound = Import.createdNewBy(null, distributor, profile)
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

      distributorIncOption =
        importDebt: -currentImport.debtBalanceChange
        importTotalCash: -currentImport.debtBalanceChange

      transactions = Schema.transactions.find({latestImport: currentImport._id})
      for transaction in transactions
        distributorIncOption.importPaid = -transaction.debtBalanceChange
        distributorIncOption.importDebt = -(currentImport.debtBalanceChange - transaction.debtBalanceChange)
        Schema.transactions.remove transaction._id

      for productDetail in productDetails
        Schema.productDetails.remove productDetail._id
        Schema.products.update productDetail.product, $inc: {
          totalQuality      : -productDetail.importQuality
          availableQuality  : -productDetail.importQuality
          inStockQuality    : -productDetail.importQuality
        }

      Schema.imports.remove currentImport._id
      Schema.importDetails.find({import: currentImport._id}).forEach((detail)-> Schema.importDetails.remove detail._id)

      Schema.distributors.update currentImport.distributor, $inc: distributorIncOption
    catch error
      throw new Meteor.Error('deleteTransaction', error)


  distributorManagementDeleteTransaction: (transactionId)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()}); if !profile then throw 'Không tìm thấy profile'
      currentTransaction = Schema.transactions.findOne(transactionId); if !currentTransaction then throw 'Không tìm thấy Transaction'
      currentImport = Schema.imports.findOne(currentTransaction.latestImport)
      throw 'Không tìm thấy Import.' if !currentImport

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

      tempBeforeDebtBalance = currentImport.beforeDebtBalance
      Schema.imports.find({distributor: currentImport.distributor, 'version.createdAt': {$gte: currentImport.version.createdAt} }
      , {sort: {'version.createdAt': 1}}).forEach(
        (myImport) ->
          Schema.imports.update myImport._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + myImport.debtBalanceChange
          }
          tempBeforeDebtBalance += myImport.debtBalanceChange
          Schema.transactions.find({latestImport: myImport._id}).forEach(
            (transaction) ->
              Schema.transactions.update transaction._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - transaction.debtBalanceChange
              }
              tempBeforeDebtBalance -= transaction.debtBalanceChange
          )
      )

      Schema.distributors.update currentImport.distributor, $inc: distributorIncOption
    catch error
      throw new Meteor.Error('deleteTransaction', error)

