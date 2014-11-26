scope = logics.staffManagement

lemon.defineHyper Template.staffManagementSalesHistorySection,
  customSale: -> Schema.customSales.find({buyer: Session.get("staffManagementCurrentStaff")?._id}, {sort: {debtDate: -1}})
  defaultSale: -> Schema.sales.find({buyer: Session.get("staffManagementCurrentStaff")?._id}, {sort: {'version.createdAt': -1}})
  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
    @ui.$totalCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$depositCash.inputmask("numeric", {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .create-customSale": (event, template) -> scope.createCustomSale(event, template)
    "click .delete-customSale": (event, template) -> scope.deleteCustomSale(@_id)