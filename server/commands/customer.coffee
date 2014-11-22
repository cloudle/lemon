Meteor.methods
  updateCustomerDebitAndPurchase: ->
    allTransactions = Schema.transactions.find({group: {$in:['sale', 'customer']} }).fetch()
    for customerId in _.union(_.pluck(allTransactions, 'owner'))
      Schema.customers.update(customerId, $set:{totalPurchases: 0,  totalDebit: 0})
    for transaction in allTransactions
      Schema.customers.update transaction.owner, $inc:{totalPurchases: transaction.totalCash,  totalDebit: transaction.debitCash}
