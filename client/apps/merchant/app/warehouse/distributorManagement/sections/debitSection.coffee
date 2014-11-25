scope = logics.distributorManagement

lemon.defineWidget Template.distributorManagementDebitSection,
  oldTransaction: ->
    Schema.transactions.find({
      owner     : Session.get("distributorManagementCurrentDistributor")._id
      group     : 'distributor'
      status    : 'tracking'
      receivable: false
    })

  newTransaction: ->
    Schema.transactions.find({
      owner     : Session.get("distributorManagementCurrentDistributor")._id
      group     : 'import'
      status    : 'tracking'
      receivable: false
    })

  events:
  #click xem chi tiet
    "click .transactionDetail": (event, template) ->
#      Meteor.subscribe('transactionDetails', Session.get("currentTransaction")._id)

    "click .create-transaction": (event, template) ->
      scope.createTransaction(event, template)

    "click .delete-transaction": (event, template) ->
      Meteor.call 'deleteTransaction', @_id, (error, result) -> if error then console.log error
