logics.distributorManagement = {}
Apps.Merchant.distributorManagementInit = []
Apps.Merchant.distributorManagementReactive = []

Apps.Merchant.distributorManagementReactive.push (scope) ->
#  if Session.get('allowCreateDistributor') then allowCreate = '' else allowCreate = 'disabled'
#  scope.allowCreateDistributor = allowCreate

  if distributor = Session.get("distributorManagementCurrentDistributor")
    maxRecords = Session.get("distributorManagementDataMaxCurrentRecords")
    countRecords = Schema.customImports.find({seller: distributor._id}).count()
    countRecords += Schema.imports.find({distributor: distributor._id, finish: true, submitted: true}).count() if distributor.customImportModeEnabled is false
    Session.set("showExpandImportAndCustomImport", (maxRecords is countRecords))

  if distributorId = Session.get("mySession")?.currentDistributorManagementSelection
    Session.set("distributorManagementCurrentDistributor", Schema.distributors.findOne(distributorId))

    if latestCustomImport = Schema.customImports.findOne({seller: distributorId}, {sort: {debtDate: -1}})
      if latestTransaction = Schema.transactions.findOne({latestImport: latestCustomImport._id}, {sort: {debtDate: -1}})
        $("[name=paidDate]").val(moment(latestTransaction.debtDate).format('DDMMYYYY'))
      else
        $("[name=paidDate]").val(moment(latestCustomImport.debtDate).format('DDMMYYYY'))

      $("[name=customImportDebtDate]").val(moment(latestCustomImport.debtDate).format('DDMMYYYY'))
    else
      $("[name=paidDate]").val('')
      $("[name=customImportDebtDate]").val('')

  if returnDetail = Session.get("distributorManagementReturnDetailEditingRowId")
    Session.set("distributorManagementReturnDetailEditingRow", Schema.returnDetails.findOne(returnDetail))
