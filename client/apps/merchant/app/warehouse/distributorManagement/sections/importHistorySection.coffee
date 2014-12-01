scope = logics.distributorManagement

lemon.defineHyper Template.distributorManagementImportsHistorySection,
  showImportHistory: -> Session.get("distributorManagementShowHistory")
  isCustomImportModeEnabled: ->
    if Session.get("distributorManagementCurrentDistributor")?.customImportModeEnabled then "" else "display: none;"
  
  
  customImport: -> Schema.customImports.find({buyer: Session.get("distributorManagementCurrentDistributor")?._id})
  defaultImport: -> Schema.imports.find({buyer: Session.get("distributorManagementCurrentDistributor")?._id})

  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
#    @ui.$totalCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
#    @ui.$depositCash.inputmask("numeric", {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandImportHistory": -> Session.set("distributorManagementShowHistory", true)
    "click .customImportModeDisable":  (event, template) ->
      if Session.get("distributorManagementCurrentDistributor")
        scope.customImportModeDisable(Session.get("distributorManagementCurrentDistributor")._id)

    "click .createCustomImport":  (event, template) ->
      console.log 'create'
      scope.createCustomImport(template)
    "keypress input.new-bill-field": (event, template) ->
      scope.createCustomImport(template) if event.which is 13

    "click .createTransaction": (event, template) -> scope.createTransactionOfCustomImport(template)
    "keypress input.new-transaction-field": (event, template) ->
      scope.createTransactionOfCustomImport(template) if event.which is 13




