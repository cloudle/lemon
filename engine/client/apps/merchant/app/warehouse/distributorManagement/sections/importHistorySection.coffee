scope = logics.distributorManagement

lemon.defineHyper Template.distributorManagementImportsHistorySection,
  finalDebtBalance: -> @customImportDebt + @importDebt
  allowCreateCustomImport: -> if Session.get("allowCreateCustomImport") then '' else 'disabled'
  allowCreateTransactionOfImport: -> if Session.get("allowCreateTransactionOfImport") then '' else 'disabled'
  allowCreateTransactionOfCustomImport: -> if Session.get("allowCreateTransactionOfCustomImport") then '' else 'disabled'

  showExpandImportAndCustomImport: -> Session.get("showExpandImportAndCustomImport")
  isCustomImportModeEnabled: -> if Session.get("distributorManagementCurrentDistributor")?.customImportModeEnabled then "" else "display: none;"

  customImport: -> Schema.customImports.find({seller: Session.get("distributorManagementCurrentDistributor")?._id}, {sort: {debtDate: 1, 'version.createdAt': 1}})
  defaultImport: ->
    if distributor = Session.get("distributorManagementCurrentDistributor")
      Schema.imports.find({distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': 1}})
  returnImport: ->
    if distributor = Session.get("distributorManagementCurrentDistributor")
      Schema.returns.find({distributor: distributor._id, allowDelete: true})


  rendered: ->
    @ui.$customImportDebtDate.inputmask("dd/mm/yyyy")
    @ui.$paidDate.inputmask("dd/mm/yyyy")
    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

    @ui.$payImportAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandImportAndCustomImport": ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        limitExpand = Session.get("mySession").limitExpandImportAndCustomImport ? 5
        if distributor.customImportModeEnabled
          currentRecords = Schema.customImports.find({seller: distributor._id}).count()
        else
          currentRecords = Schema.customImports.find({seller: distributor._id}).count() + Schema.imports.find({distributor: distributor._id, finish: true, submitted: true}).count()
        Meteor.subscribe('distributorManagementData', distributor._id, currentRecords, limitExpand)
        Session.set("distributorManagementDataRecordCount", currentRecords)
        Session.set("distributorManagementDataMaxCurrentRecords", currentRecords + limitExpand)

    "click .customImportModeDisable":  (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        scope.customImportModeDisable(distributor._id)

#----Create-Custom-Import-----------------------------------------------------------------------------------------------
    "keydown .new-bill-field": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor") and event.which is 8 #Backspaces
        scope.checkAllowCreateCustomImport(template, distributor)

    "input .new-bill-field": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor") #Input
        scope.checkAllowCreateCustomImport(template, distributor)

    "keypress .new-bill-field": (event, template) ->
      if  Session.get("allowCreateCustomImport") and event.which is 13 #Enter
        scope.createCustomImport(template)

    "click .createCustomImport":  (event, template) ->
      if Session.get("allowCreateCustomImport") #Click
        scope.createCustomImport(template)

#-----Create-Transaction-Of-Custom-Import-------------------------------------------------------------------------------
    "keydown input.new-transaction-custom-import-field": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor") and event.which is 8
        scope.checkAllowCreateTransactionOfCustomImport(template, distributor)

    "click .createTransactionOfCustomImport": (event, template) ->
      if Session.get("allowCreateTransactionOfCustomImport")
        scope.createTransactionOfCustomImport(template)

    "keypress input.new-transaction-custom-import-field": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        scope.checkAllowCreateTransactionOfCustomImport(template, distributor)
        if Session.get("allowCreateTransactionOfCustomImport") and event.which is 13
          scope.createTransactionOfCustomImport(template)

#----Create-Transaction-Of-Import-----------------------------------------------------------------------------------------
    "keydown input.new-transaction-import-field": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        scope.checkAllowCreateTransactionOfImport(template, distributor) if event.which is 8

    "click .createTransactionOfImport": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        if Session.get("allowCreateTransactionOfImport")
          scope.createTransactionOfImport(template, distributor)

    "keypress input.new-transaction-import-field": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        scope.checkAllowCreateTransactionOfImport(template, distributor)
        if Session.get("allowCreateTransactionOfImport") and event.which is 13
          scope.createTransactionOfImport(template, distributor)



