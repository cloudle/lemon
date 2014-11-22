Meteor.methods
  updateCustomerDebitAndPurchase: ->
    for customerId in Schema.customers.find({}).fetch()
      Schema.customers.update(customerId, $set:{totalPurchases: 0,  totalDebit: 0})
    for transaction in Schema.transactions.find({group: {$in:['sale', 'customer']} }).fetch()
      Schema.customers.update transaction.owner, $inc:{totalPurchases: transaction.totalCash,  totalDebit: transaction.debitCash}
