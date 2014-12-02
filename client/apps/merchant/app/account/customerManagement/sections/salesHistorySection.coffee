scope = logics.customerManagement

lemon.defineHyper Template.customerManagementSalesHistorySection,
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  isCustomSaleModeEnabled: -> if Session.get("customerManagementCurrentCustomer")?.customSaleModeEnabled then "" else "display: none;"

  customSale: -> Schema.customSales.find({buyer: Session.get("customerManagementCurrentCustomer")?._id}, {sort: {debtDate: 1}})
  defaultSale: -> Schema.sales.find({buyer: Session.get("customerManagementCurrentCustomer")?._id}, {sort: {'version.createdAt': -1}})
  defaultSaleArchive: -> Schema.sales.find {
      buyer               : Session.get("customerManagementCurrentCustomer")?._id,
      'version.createdAt' : {$lt: new Date((new Date).toDateString())}
    }, {sort: {'version.createdAt': 1}}
  defaultSaleToday: -> Schema.sales.find {
      buyer               : Session.get("customerManagementCurrentCustomer")?._id,
      'version.createdAt' : {$gte: new Date((new Date).toDateString())}
    }, {sort: {'version.createdAt': 1}}

  finalDebtBalance: -> @customSaleDebt + @saleDebt
  showExpandSaleAndCustomSale: -> Session.get("showExpandSaleAndCustomSale")


  allowCreateCustomSale: -> if Session.get("allowCreateCustomSale") then '' else 'disabled'
  allowCreateTransactionOfSale: -> if Session.get("allowCreateTransactionOfSale") then '' else 'disabled'
  allowCreateTransactionOfCustomSale: -> if Session.get("allowCreateTransactionOfCustomSale") then '' else 'disabled'

  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$paidDate.inputmask("dd/mm/yyyy")

  events:
    "input .new-transaction-custom-sale-field": (event, template) ->
      scope.checkAllowCreateTransactionOfCustomSale(customer) if customer = Session.get("customerManagementCurrentCustomer")

    "click .expandSaleAndCustomSale": ->
      scope.subscribeSaleAndCustomSale(customer) if customer = Session.get("customerManagementCurrentCustomer")

    "click .customSaleModeDisable":  (event, template) ->
      scope.customSaleModeDisable(customer._id) if customer = Session.get("customerManagementCurrentCustomer")

    "click .createCustomSale":  (event, template) ->
      scope.createCustomSale(template) if Session.get("allowCreateCustomSale")
    "keypress input.new-bill-field": (event, template) ->
      scope.createCustomSale(template) if event.which is 13 and Session.get("allowCreateCustomSale")

    "click .createTransactionOfCustomSale": (event, template) ->
      scope.createTransactionOfCustomSale(template) if Session.get("allowCreateTransactionOfCustomSale")
    "keypress input.new-transaction-custom-sale-field": (event, template) ->
      scope.createTransactionOfCustomSale(template) if event.which is 13 and Session.get("allowCreateTransactionOfCustomSale")

    "click .createTransactionOfSale": (event, template) ->
      scope.createTransactionOfSale(template) if Session.get("allowCreateTransactionOfSale")
    "keypress input.new-transaction-sale-field": (event, template) ->
      scope.createTransactionOfSale(template) if event.which is 13 and Session.get("allowCreateTransactionOfSale")
