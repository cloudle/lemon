scope = logics.distributorManagement

lemon.defineHyper Template.distributorManagementImportsHistorySection,
  customImportDetail: ->Schema.customImportDetails.find({})
  customImport: -> Schema.customImports.find({buyer: Session.get("distributorManagementCurrentDistributor")?._id})
  defaultImport: -> Schema.sales.find({buyer: Session.get("distributorManagementCurrentDistributor")?._id})
  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
    @ui.$totalCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$depositCash.inputmask("numeric", {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .create-customImport": (event, template) -> scope.createCustomImport(event, template)
    "click .delete-customImport": (event, template) -> scope.deleteCustomImport(@_id)

    "click .create-customImportDetail": (event, template) ->
      customImportId = Session.get('distributorManagementCustomImportId')
      scope.createCustomImportDetail(customImportId, template)
    "click .pay-customImportDetail": (event, template) -> scope.payCustomImportDetail(@_id, true)
    "click .unPay-customImportDetail": (event, template) -> scope.payCustomImportDetail(@_id, false)
    "click .delete-customImportDetail": (event, template) -> scope.deleteCustomImportDetail(@_id)
