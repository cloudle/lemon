updateDistributorDenyDelete = (id)-> Schema.distributors.update id, $set: {allowDelete: false}
updateCustomImportDenyDelete = (id)-> Schema.customImports.update id, $set: {allowDelete: false}
updateTransactionAllowDelete = (id)-> Schema.transactions.update id, $set: {allowDelete: false}

findLatestCustomImportByDistributorId = (distributorId)->
  Schema.customImports.findOne({seller: distributorId}, {sort: {debtDate: -1, 'version.createdAt': -1}})

#----------Create-Custom-Import-------------------
updateLatestTransactionDenyDelete = (ownerId)->
  latestTransactions = Schema.transactions.find({owner: ownerId, allowDelete: true}).fetch()
  (Schema.transactions.update transaction._id, $set:{allowDelete: false}) for transaction in latestTransactions

updateCustomImportDetailDenyDelete = (latestCustomImportId)->
  latestCustomImportDetails = Schema.customImportDetails.find({customImport: latestCustomImportId})
  if latestCustomImportDetails.count() > 0
    for customImportDetail in latestCustomImportDetails.fetch()
      Schema.customImportDetails.update customImportDetail._id, $set:{allowDelete: false}
    Schema.customImports.update latestCustomImportId, $set:{allowDelete: false}

#----------Delete-Custom-Import-------------------
checkAndRemoveCustomImport = (customImportId, latestCustomImportId, distributorId, debtBalanceChange)->
  if customImportId is latestCustomImportId
    customImportDetails = Schema.customImportDetails.find({customImport: customImportId})
    if customImportDetails.count() > 0
      Schema.customImportDetails.remove customImportDetail._id for customImportDetail in customImportDetails.fetch()
      Schema.distributors.update distributorId, $inc: {customImportDebt: -debtBalanceChange, customImportTotalCash: -debtBalanceChange}
    Schema.customImports.remove customImportId

    transactions = Schema.transactions.find({latestImport: customImportId})
    if transactions.count() > 0
      incCustomerOption = {customImportDebt: 0, customImportPaid: 0}
      for transaction in transactions.fetch()
        incCustomerOption.customImportDebt += transaction.debtBalanceChange
        incCustomerOption.customImportPaid -= transaction.debtBalanceChange
        Schema.transactions.remove transaction._id
      Schema.distributors.update distributorId, $inc: incCustomerOption
  else
    Schema.customImports.remove customImportId if Schema.customImportDetails.find({customImport: customImportId}).count() is 0

updateAllowDeleteCustomImportAndDetailAndTransactionBy = (customImportId)->
  for customImportDetail in Schema.customImportDetails.find({customImport: customImportId}).fetch()
    Schema.customImportDetails.update customImportDetail._id, $set:{allowDelete: true}

  if latestTransaction = Schema.transactions.findOne({latestImport: customImportId}, {sort: {debtDate: -1, 'version.createdAt': -1}})
    Schema.transactions.update latestTransaction._id, $set:{allowDelete: true}
  else
    Schema.customImports.update customImportId, $set:{allowDelete: true}

checkUpdateDistributorAllowDelete = (distributorId)->
  customImportFound = Schema.customImports.findOne({seller: distributorId})
  importFound = Schema.imports.findOne({distributor: distributorId})
  Schema.distributors.update distributorId, $set:{allowDelete: true} if !customImportFound and !importFound

#----------Create-Delete-Custom-Import-Detail-------------------
updateDistributorAndCustomImportByCreate = (distributorId, customImportId, cash)->
  Schema.customImports.update customImportId, $inc: {
      totalCash        : cash
      debtBalanceChange: cash
      latestDebtBalance: cash
    }
  Schema.distributors.update distributorId, $inc: {
      customImportDebt     : cash
      customImportTotalCash: cash
    }

updateDistributorAndCustomImportByDelete = (distributorId, customImportId, cash)->
  if Schema.customImportDetails.findOne({customImport: customImportId}) then setOption = {}
  else setOption = {allowDelete: true}
  incCustomImportOption = {
    totalCash        : -cash
    debtBalanceChange: -cash
    latestDebtBalance: -cash
  }
  Schema.customImports.update customImportId, $set: setOption, $inc: incCustomImportOption

  Schema.distributors.update distributorId, $inc:{
    customImportDebt     : -cash
    customImportTotalCash: -cash
  }

calculateTransactionBy = (customImportId)->
  beforeDebtBalance = Schema.customImports.findOne(customImportId).latestDebtBalance
  for transaction in Schema.transactions.find({latestImport: customImportId}).fetch()
    latestDebtBalance = beforeDebtBalance - transaction.debtBalanceChange
    Schema.transactions.update transaction._id, $set: {beforeDebtBalance: beforeDebtBalance, latestDebtBalance: latestDebtBalance}
    beforeDebtBalance = latestDebtBalance

createImportOption = (profile, distributor, paidDate)->
  option =
    parentMerchant   : profile.currentMerchant
    creator          : profile.user
    seller           : distributor._id
    debtDate         : paidDate
    description      : ''
    beforeDebtBalance: distributor.customImportDebt
    latestDebtBalance: distributor.customImportDebt

  return option

createTransactionOfCustomImport = (profile, distributor, latestCustomImportId, debtCash, paidDate, description)->
  option =
    parentMerchant    : profile.parentMerchant
    merchant          : profile.currentMerchant
    warehouse         : profile.currentWarehouse
    creator           : profile.user
    owner             : distributor._id
    latestImport      : latestCustomImportId
    group             : 'customImport'
    totalCash         : debtCash
    debtDate          : paidDate
    debtBalanceChange : debtCash
    beforeDebtBalance : distributor.customImportDebt
    latestDebtBalance : distributor.customImportDebt - debtCash

  if debtCash > 0
    option.description = if description?.length > 0 then description else 'Trả Tiền'
    option.receivable  = false
  else
    option.description = if description?.length > 0 then description else 'Mượn Tiền'
    option.receivable  = true

  Schema.transactions.insert option

createTransactionOfImport = (profile, distributor, latestImport, debtCash, paidDate, description)->
  option =
    parentMerchant    : profile.parentMerchant
    merchant          : profile.currentMerchant
    warehouse         : profile.currentWarehouse
    creator           : profile.user
    owner             : distributor._id
    latestImport      : latestImport._id
    group             : 'import'
    totalCash         : debtCash
    debtDate          : paidDate
    debtBalanceChange : debtCash
    beforeDebtBalance : distributor.importDebt
    latestDebtBalance : distributor.importDebt - debtCash

  if debtCash > 0
    option.description = if description?.length > 0 then description else 'Trả Tiền'
    option.receivable  = false
  else
    option.description = if description?.length > 0 then description else 'Mượn Tiền'
    option.receivable  = true
  Schema.transactions.insert option



Meteor.methods
  createNewCustomImport: (customImport)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      latestCustomImport = findLatestCustomImportByDistributorId(customImport.seller)
      distributor = Schema.distributors.findOne({_id: customImport.seller, parentMerchant: profile.parentMerchant})
      if distributor?.customImportModeEnabled is true
        if latestCustomImport
          if customImport.debtDate >= latestCustomImport.debtDate and customImport.debtDate < new Date()
            if Schema.customImports.insert customImport
              updateDistributorDenyDelete(distributor._id)
              updateCustomImportDetailDenyDelete(latestCustomImport._id)
              updateLatestTransactionDenyDelete(distributor._id)
        else
          updateDistributorDenyDelete(distributor._id) if Schema.customImports.insert customImport

  deleteCustomImport: (customImportId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customImport = Schema.customImports.findOne({_id: customImportId, parentMerchant: profile.parentMerchant})
        distributor = Schema.distributors.findOne(customImport.seller)
        if distributor.customImportModeEnabled is true
          if latestCustomImport = findLatestCustomImportByDistributorId(customImport.seller)
            checkAndRemoveCustomImport(customImport._id, latestCustomImport._id, distributor._id, customImport.debtBalanceChange)

          if latestCustomImport = findLatestCustomImportByDistributorId(customImport.seller)
            updateAllowDeleteCustomImportAndDetailAndTransactionBy(latestCustomImport._id)

          checkUpdateDistributorAllowDelete(distributor._id)

  updateCustomImportByCreateCustomImportDetail: (customImportDetail)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customImport = Schema.customImports.findOne({_id: customImportDetail.customImport, parentMerchant: profile.parentMerchant})
      latestCustomImport = findLatestCustomImportByDistributorId(customImport.seller)
      if customImport._id is latestCustomImport._id
        distributor = Schema.distributors.findOne({_id: customImport.seller, parentMerchant: profile.parentMerchant})
        if distributor.customImportModeEnabled is true
          if Schema.customImportDetails.insert customImportDetail
            updateDistributorAndCustomImportByCreate(distributor._id, customImport._id, customImportDetail.finalPrice)
            calculateTransactionBy(customImport._id)

  updateCustomImportByDeleteCustomImportDetail: (customImportDetailId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customImportDetail = Schema.customImportDetails.findOne({_id: customImportDetailId, parentMerchant: profile.parentMerchant})
        customImport = Schema.customImports.findOne({_id: customImportDetail.customImport, parentMerchant: profile.parentMerchant})
        latestCustomImport = findLatestCustomImportByDistributorId(customImport.seller)
        if customImport._id is latestCustomImport._id
          distributor = Schema.distributors.findOne({_id: customImport.seller, parentMerchant: profile.parentMerchant})
          if distributor.customImportModeEnabled is true
            Schema.customImportDetails.remove customImportDetail._id
            updateDistributorAndCustomImportByDelete(distributor._id, customImport._id, customImportDetail.finalPrice)
            calculateTransactionBy(customImport._id)

  createNewReceiptCashOfCustomImport: (distributorId, debtCash, description, paidDate = new Date())->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      toDate = new Date()
      paidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate())
      distributor = Schema.distributors.findOne({_id: distributorId, parentMerchant: profile.parentMerchant})
      if distributor and distributor.customImportModeEnabled is true and paidDate <= toDate
        latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})
        if latestCustomImport is undefined
          Meteor.call('createNewCustomImport', createImportOption(profile, distributor, paidDate))
          latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})

        if latestCustomImport and paidDate >= latestCustomImport.debtDate
          if latestTransaction = Schema.transactions.findOne({
              owner: distributor._id
              latestImport: latestCustomImport._id
              parentMerchant: profile.parentMerchant
          }, {sort: {debtDate: -1, 'version.createdAt': -1}}) then updateTransactionAllowDelete(latestTransaction._id)

          createTransactionOfCustomImport(profile, distributor, latestCustomImport._id, debtCash, paidDate, description)
          updateCustomImportDenyDelete(latestCustomImport._id)

          incCustomerOption = {customImportDebt: -debtCash}
          if debtCash > 0
            incCustomerOption.customImportPaid = debtCash
          else
            incCustomerOption.customImportLoan     = -debtCash
            incCustomerOption.customImportTotalCash = -debtCash
          Schema.distributors.update distributor._id, $inc: incCustomerOption

  deleteTransactionOfCustomImport: (transactionId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if transaction = Schema.transactions.findOne({_id: transactionId, parentMerchant: profile.parentMerchant})
        distributor = Schema.distributors.findOne({_id: transaction.owner})
        if distributor.customImportModeEnabled is true
          latestCustomImport = Schema.customImports.findOne({seller: transaction.owner}, {sort: {debtDate: -1, 'version.createdAt': -1}})
          latestTransaction = Schema.transactions.findOne({owner: transaction.owner, group: 'customImport', parentMerchant: profile.parentMerchant}, {sort: {debtDate: -1, 'version.createdAt': -1}})

          if transaction.latestImport is latestCustomImport._id and transaction._id is latestTransaction._id
            Schema.transactions.remove transaction._id

            incCustomerOption = {customImportDebt: transaction.debtBalanceChange }
            if transaction.debtBalanceChange > 0
              incCustomerOption.customImportPaid = -transaction.debtBalanceChange
            else
              incCustomerOption.customImportLoan      = transaction.debtBalanceChange
              incCustomerOption.customImportTotalCash = transaction.debtBalanceChange
            Schema.distributors.update transaction.owner, $inc: incCustomerOption

            latestTransaction = Schema.transactions.findOne({latestImport: latestCustomImport._id, group: 'customImport', parentMerchant: profile.parentMerchant}, {sort: {debtDate: -1, 'version.createdAt': -1}})
            if latestTransaction
              Schema.transactions.update latestTransaction._id, $set:{allowDelete: true}
            else
              Schema.customImports.update latestCustomImport._id, $set:{allowDelete: true}

  createNewReceiptCashOfImport: (distributorId, debtCash, description)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if distributor = Schema.distributors.findOne({_id: distributorId, parentMerchant: profile.parentMerchant})
        latestImport = Schema.imports.findOne({distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
        if !latestImport
          importOption =
            parentMerchant: profile.parentMerchant
            merchant      : profile.currentMerchant
            warehouse     : profile.currentWarehouse
            creator       : profile.user
            distributor   : distributor._id
            finish        : true
            submitted     : true
          newImportId = Schema.imports.insert importOption
          latestImport = Schema.imports.findOne(newImportId)

        if latestImport
          createTransactionOfImport(profile, distributor, latestImport, debtCash,  new Date(), description)
          updateCustomImportDenyDelete(latestImport._id)

          incCustomerOption = {importDebt: -debtCash}
          if debtCash > 0
            incCustomerOption.importPaid = debtCash
          else
            incCustomerOption.importLoan     = -debtCash
            incCustomerOption.importTotalCash = -debtCash
          Schema.distributors.update distributor._id, $inc: incCustomerOption


  calculateCustomImportByDistributor: (distributorId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if distributor = Schema.distributors.findOne({_id: distributorId, parentMerchant: profile.parentMerchant})
        distributorOption = {
          customImportDebt     : 0
          customImportPaid     : 0
          customImportTotalCash: 0
        }
        allCustomImport = Schema.customImports.find({seller: distributor._id}, {sort: {'version.createdAt': 1}})
        allCustomImport.forEach(
          (customImport)->
            customImportOption = {
              beforeDebtBalance: distributorOption.customImportDebt
              latestDebtBalance: distributorOption.customImportDebt + customImport.debtBalanceChange
            }
            Schema.customImports.update customImport._id, $set: customImportOption

            distributorOption.customImportDebt      += customImport.debtBalanceChange
            distributorOption.customImportTotalCash += customImport.debtBalanceChange

            Schema.transactions.find({owner: distributor._id, latestImport: customImport._id, group: "customImport"}, {sort: {debtDate: 1}}).forEach(
              (transaction)->
                transactionOption = {
                  beforeDebtBalance: distributorOption.customImportDebt
                  latestDebtBalance: distributorOption.customImportDebt - transaction.debtBalanceChange
                }
                Schema.transactions.update transaction._id, $set: transactionOption

                distributorOption.customImportDebt = transactionOption.latestDebtBalance
                if transaction.debtBalanceChange > 0
                  distributorOption.customImportPaid += transaction.debtBalanceChange
                else
                  distributorOption.customImportLoan      += -transaction.debtBalanceChange
                  distributorOption.customImportTotalCash += -transaction.debtBalanceChange
            )
        )
        Schema.distributors.update distributor._id, $set: distributorOption

  calculateImportByDistributor: (distributorId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if distributor = Schema.distributors.findOne({_id: distributorId, parentMerchant: profile.parentMerchant})
        distributorOption = {
          importDebt: 0
          importPaid: 0
          importTotalCash: 0
        }

        allImport = Schema.imports.find({distributor: distributor._id}, {sort: {'version.createdAt': 1}})
        allImport.forEach(
          (currentImport)->
            importOption = {
              beforeDebtBalance: distributorOption.importDebt
              debtBalanceChange: currentImport.debtBalanceChange
              latestDebtBalance: distributorOption.importDebt + currentImport.debtBalanceChange
            }
            Schema.imports.update currentImport._id, $set: importOption

            distributorOption.importDebt      += currentImport.debtBalanceChange
            distributorOption.importTotalCash += currentImport.debtBalanceChange

            Schema.transactions.find({owner: distributor._id, latestImport: currentImport._id, group: "import"}, {sort: {debtDate: 1}}).forEach(
              (transaction)->
                transactionOption = {
                  beforeDebtBalance: distributorOption.importDebt
                  latestDebtBalance: distributorOption.importDebt - transaction.debtBalanceChange
                }
                Schema.transactions.update transaction._id, $set: transactionOption

                distributorOption.importDebt = transactionOption.latestDebtBalance
                if transaction.debtBalanceChange > 0
                  distributorOption.importPaid += transaction.debtBalanceChange
                else
                  distributorOption.importTotalCash += -transaction.debtBalanceChange
            )
        )
        Schema.distributors.update distributor._id, $set: distributorOption
