scope = logics.distributorManagement

lemon.defineHyper Template.distributorManagementImportsHistorySection,
  finalDebtBalance: -> @customSaleDebt + @saleDebt
  allowCreateCustomImport: -> if Session.get("allowCreateCustomImport") then '' else 'disabled'
#  allowCreateTransactionOfImport: -> if Session.get("allowCreateTransactionOfImport") then '' else 'disabled'
  allowCreateTransactionOfCustomImport: -> if Session.get("allowCreateTransactionOfCustomImport") then '' else 'disabled'

  showExpandImportAndCustomImport: -> Session.get("showExpandImportAndCustomImport")
  isCustomImportModeEnabled: -> if Session.get("distributorManagementCurrentDistributor")?.customImportModeEnabled then "" else "display: none;"

  customImport: -> Schema.customImports.find({seller: Session.get("distributorManagementCurrentDistributor")?._id})
  defaultImport: -> Schema.imports.find({buyer: Session.get("distributorManagementCurrentDistributor")?._id})

  rendered: ->
    @ui.$customImportDebtDate.inputmask("dd/mm/yyyy")
    @ui.$paidDate.inputmask("dd/mm/yyyy")
    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandImportAndCustomImport": ->
#      if customer = Session.get("customerManagementCurrentCustomer")
#        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
#        if customer.customSaleModeEnabled
#          currentRecords = Schema.customSales.find({buyer: customer._id}).count()
#        else
#          currentRecords = Schema.customSales.find({buyer: customer._id}).count() + Schema.sales.find({buyer: customer._id}).count()
#        Meteor.subscribe('customerManagementData', customer._id, currentRecords, limitExpand)
#        Session.set("customerManagementDataMaxCurrentRecords", currentRecords + limitExpand)

    "click .customImportModeDisable":  (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        scope.customImportModeDisable(distributor._id)

#----Create-Custom-Import-----------------------------------------------------------------------------------------------
    "keydown .new-bill-field.number": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor") and event.which is 8
        scope.checkAllowCreateCustomImport(template, distributor)

    "input .new-bill-field.number": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        scope.checkAllowCreateCustomImport(template, distributor)

    "click .createCustomImport":  (event, template) ->
      if Session.get("allowCreateCustomImport")
        scope.createCustomImport(template)

    "keypress input.new-bill-field": (event, template) ->
      if  Session.get("allowCreateCustomImport") and event.which is 13
        scope.createCustomImport(template)

#-----Create-Transaction-Of-Custom-Import-------------------------------------------------------------------------------
    "keydown .new-transaction-custom-import-field": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        scope.checkAllowCreateTransactionOfCustomImport(template, distributor)

    "click .createTransactionOfCustomImport": (event, template) ->
      if Session.get("allowCreateTransactionOfCustomImport")
        scope.createTransactionOfCustomImport(template)

    "keypress input.new-transaction-custom-import-field": (event, template) ->
      if Session.get("allowCreateTransactionOfCustomImport") and event.which is 13
        scope.createTransactionOfCustomImport(template)

#----Create-Transaction-Of-Import-----------------------------------------------------------------------------------------




