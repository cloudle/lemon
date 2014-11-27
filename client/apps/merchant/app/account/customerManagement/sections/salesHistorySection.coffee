scope = logics.customerManagement

lemon.defineHyper Template.customerManagementSalesHistorySection,
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  showSaleHistory: -> Session.get("customerManagementShowHistory")

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
    "click .createCustomSale": (event, template) -> scope.createCustomSale(event, template)
    "click .expandSaleHistory": -> Session.set("customerManagementShowHistory", true)