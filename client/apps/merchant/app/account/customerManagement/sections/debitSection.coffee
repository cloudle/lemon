scope = logics.customerManagement

lemon.defineWidget Template.customerManagementDebitSection,
  customSale: ->
    Schema.customSales.find({buyer: Session.get("customerManagementCurrentCustomer")._id})

  defaultSale: ->
    Schema.sales.find({buyer: Session.get("customerManagementCurrentCustomer")._id})

  events:
  #click xem chi tiet
    "click .transactionDetail": (event, template) ->
#      Meteor.subscribe('transactionDetails', Session.get("currentTransaction")._id)

    "click .create-transaction": (event, template) ->
      scope.createTransaction(event, template)

    "click .delete-transaction": (event, template) ->
      Meteor.call 'deleteTransaction', @_id, (error, result) -> if error then console.log error
