Meteor.methods
  updateCustomerDebitAndPurchase: ->
    for customer in Schema.customers.find({}).fetch()
      Schema.customers.update(customer._id, $set:{totalPurchases: 0,  totalDebit: 0})
    for transaction in Schema.transactions.find({group: {$in:['sale', 'customer']}, receivable: true }).fetch()
      Schema.customers.update transaction.owner, $inc:{totalPurchases: transaction.totalCash,  totalDebit: transaction.debitCash}

  createNewReceiptCashOfCustomer: (customerId, debtCash, description)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customer = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
        option =
          merchant    : profile.currentMerchant
          warehouse   : profile.currentWarehouse
          creator     : profile.user
          owner       : customer._id
          group       : 'customSale'
          receivable  : false
          description : description ? 'Phiếu Thu'
          totalCash   : debtCash
          status      : 'done'

        option.debtBalanceChange = option.totalCash
        option.latestDebtBalance = customer.debtBalance - debtCash
        Schema.transactions.insert option
        Schema.customers.update customer._id, $inc:{debtBalance: -debtCash}


