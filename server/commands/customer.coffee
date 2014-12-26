Meteor.methods
  updateCustomerDebitAndPurchase: ->
    for customer in Schema.customers.find({}).fetch()
      Schema.customers.update(customer._id, $set:{totalPurchases: 0,  totalDebit: 0})
    for transaction in Schema.transactions.find({group: {$in:['sale', 'customer']}, receivable: true }).fetch()
      Schema.customers.update transaction.owner, $inc:{totalPurchases: transaction.totalCash,  totalDebit: transaction.debitCash}





#  updateImportAndImport: ->
#    Schema.imports.find({finish: true, submitted: true}).forEach((item)-> Schema.imports.update item._id, $set: {'version.createdAt': item.version.updateAt})
#    Schema.returns.find({status: 2}).forEach((item)-> Schema.returns.update item._id, $set: {'version.createdAt': item.version.updateAt})