scope = logics.customerManagement

lemon.defineHyper Template.customerManagementSalesHistorySection,
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  showSaleHistory: -> Session.get("customerManagementShowHistory")

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

  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$paidDate.inputmask("dd/mm/yyyy")
#    @ui.$totalCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
#    @ui.$depositCash.inputmask("numeric", {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandSaleHistory": -> Session.set("customerManagementShowHistory", true)
    "click .expandSaleAndCustomSale": ->
      if customer = Session.get("customerManagementCurrentCustomer")
        if customer.customSaleModeEnabled
          currentRecords = Schema.customSales.find({buyer: customer._id}).count()
        else
          currentRecords = Schema.customSales.find({buyer: customer._id}).count() + Schema.sales.find({buyer: customer._id}).count()
        console.log 'currentRecords:' + currentRecords
        Meteor.subscribe('customerManagementData', Session.get("customerManagementCurrentCustomer")._id, currentRecords)
    "click .customSaleModeDisable":  (event, template) ->
      if Session.get("customerManagementCurrentCustomer")
        scope.customSaleModeDisable(Session.get("customerManagementCurrentCustomer")._id)

    "click .createCustomSale":  (event, template) -> scope.createCustomSale(template)
    "keypress input.new-bill-field": (event, template) ->
      scope.createCustomSale(template) if event.which is 13

    "click .createTransactionOfCustomSale": (event, template) -> scope.createTransactionOfCustomSale(template)
    "keypress input.new-transaction-field": (event, template) ->
      scope.createTransactionOfCustomSale(template) if event.which is 13