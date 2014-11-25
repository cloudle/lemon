scope = logics.customerManagement

lemon.defineHyper Template.customerManagementSalesHistorySection,
  customSaleDetail: ->Schema.customSaleDetails.find({})
  customSale: -> Schema.customSales.find({buyer: Session.get("customerManagementCurrentCustomer")._id})
  defaultSale: -> Schema.sales.find({buyer: Session.get("customerManagementCurrentCustomer")._id})
  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
    @ui.$totalCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$depositCash.inputmask("numeric", {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .create-customSale": (event, template) -> scope.createCustomSale(event, template)
    "click .delete-customSale": (event, template) -> scope.deleteCustomSale(@_id)

    "click .create-customSaleDetail": (event, template) ->
      customSaleId = "JDbiv8pZcuE64u6vB"
      scope.createCustomSaleDetail(customSaleId, template)
    "click .pay-customSaleDetail": (event, template) -> scope.payCustomSaleDetail(@_id, true)
    "click .unPay-customSaleDetail": (event, template) -> scope.payCustomSaleDetail(@_id, false)
    "click .delete-customSaleDetails": (event, template) -> scope.deleteCustomSaleDetail(@_id)
