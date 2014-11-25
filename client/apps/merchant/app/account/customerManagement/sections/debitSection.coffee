scope = logics.customerManagement

lemon.defineHyper Template.customerManagementDebitSection,
  customSale: ->
    Schema.customSales.find({buyer: Session.get("customerManagementCurrentCustomer")._id})

  defaultSale: ->
    Schema.sales.find({buyer: Session.get("customerManagementCurrentCustomer")._id})

  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
    @ui.$totalCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$depositCash.inputmask("numeric", {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
  #click xem chi tiet
    "click .transactionDetail": (event, template) ->
#      Meteor.subscribe('transactionDetails', Session.get("currentTransaction")._id)

    "click .create-transaction": (event, template) ->
      scope.createTransaction(event, template)

    "click .delete-transaction": (event, template) ->
      Meteor.call 'deleteTransaction', @_id, (error, result) -> if error then console.log error
