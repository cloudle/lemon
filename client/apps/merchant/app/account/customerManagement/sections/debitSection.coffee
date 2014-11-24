scope = logics.customerManagement

lemon.defineWidget Template.customerManagementDebitSection,
  oldTransaction: ->
    Schema.transactions.find({
      owner : Session.get("customerManagementCurrentCustomer")._id
      group : 'customer'
      status: 'tracking'
    })

  newTransaction: ->
    Schema.transactions.find({
      owner : Session.get("customerManagementCurrentCustomer")._id
      group : 'sale'
      status: 'tracking'
    })

  events:
  #click xem chi tiet
    "click .transactionDetail": (event, template) ->
#      Meteor.subscribe('transactionDetails', Session.get("currentTransaction")._id)

    "click .create-transaction": (event, template) ->
      scope.createTransaction(event, template)

    "click .delete-transaction": (event, template) ->
      Meteor.call 'deleteTransaction', @_id, (error, result) -> if error then console.log error
