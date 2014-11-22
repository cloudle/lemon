Meteor.methods
  updateCustomerDebitAndPurchase: ->
    for customer in Schema.customers.find({}).fetch()
      Schema.customers.update(customer._id, $set:{totalPurchases: 0,  totalDebit: 0})
    for transaction in Schema.transactions.find({group: {$in:['sale', 'customer']} }).fetch()
      Schema.customers.update transaction.owner, $inc:{totalPurchases: transaction.totalCash,  totalDebit: transaction.debitCash}
