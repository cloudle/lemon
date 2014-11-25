Meteor.methods
  updateDistributorDebitAndSale: ->
    for distributor in Schema.distributors.find({}).fetch()
      setOption = {totalSales: 0,  totalDebit: 0}
      Schema.distributors.update distributor._id, $set: setOption

    for transaction in Schema.transactions.find({group: {$in:['import', 'distributor']} , receivable: false}).fetch()
      setOption = {allowDelete: false}
      incOption = {totalSales: transaction.totalCash,  totalDebit: transaction.debitCash}
      Schema.distributors.update transaction.owner, $set: setOption, $inc: incOption
