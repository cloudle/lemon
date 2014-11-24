Schema.add 'transactions', "Transaction", class Transaction
  @newBySale: (sale)->
    option =
      merchant    : sale.merchant
      warehouse   : sale.warehouse
      parent      : sale._id
      creator     : sale.seller
      owner       : sale.buyer
      styles      : sale.styles ? Helpers.RandomColor()
      group       : 'sale'
      receivable  : true
      totalCash   : sale.finalPrice
      depositCash : sale.deposit
      debitCash   : sale.debit
      allowDelete : false
    if sale.paymentMethod == 0
      option.dueDay = new Date()
      option.status = 'closed'
    else
  #    transaction.dueDay = new Date()
      option.status = 'tracking'
    option._id = Schema.transactions.insert option
    option

  @newByReturn: (returns)->
    option =
      merchant    : returns.merchant
      warehouse   : returns.warehouse
      parent      : returns._id
      creator     : returns.creator
      owner       : Schema.sales.findOne(returns.sale).buyer
      group       : 'return'
      receivable  : false
      totalCash   : returns.finallyPrice
      depositCash : returns.finallyPrice
      debitCash   : 0
      dueDay      : new Date()
      allowDelete : false
      status      : 'closed'
    option._id = Schema.transactions.insert option
    option

  @newByImport: (imports)->
    option =
      merchant    : imports.merchant
      warehouse   : imports.warehouse
      parent      : imports._id
      owner       : imports.distributor
      creator     : Meteor.userId()
      group       : 'import'
      receivable  : false
      totalCash   : imports.totalPrice
      depositCash : imports.deposit
      debitCash   : imports.debit
      allowDelete : false

    if imports.debit == 0
      option.dueDay = new Date()
      option.status = 'closed'
    else
      option.status = 'tracking'

    option._id = Schema.transactions.insert option
    option

  @newByUser: (customerId, description, totalCash, depositCash, debtDate)->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    customer  = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
    if profile and customer and depositCash >= 0 and totalCash >= depositCash
      option =
        merchant    : profile.currentMerchant
        warehouse   : profile.currentWarehouse
        creator     : profile.user
        owner       : customer._id
        group       : 'customer'
        receivable  : true
        description : description
        totalCash   : totalCash
        depositCash : depositCash
        debitCash   : (totalCash - depositCash)
        debtDate    : debtDate if debtDate

      if option.debit is 0
        option.dueDay = new Date()
        option.status = 'closed'
      else
        option.status = 'tracking'

      option._id = Schema.transactions.insert option
      if option._id
        TransactionDetail.newByTransaction(option)
        MetroSummary.updateMetroSummaryByNewTransaction(option.merchant, option.debitCash)
        Schema.customers.update customer._id, $inc:{totalPurchases: option.totalCash, totalDebit: option.debitCash}
      option
