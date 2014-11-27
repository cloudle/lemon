Meteor.methods
  updateCustomerDebitAndPurchase: ->
    for customer in Schema.customers.find({}).fetch()
      Schema.customers.update(customer._id, $set:{totalPurchases: 0,  totalDebit: 0})
    for transaction in Schema.transactions.find({group: {$in:['sale', 'customer']}, receivable: true }).fetch()
      Schema.customers.update transaction.owner, $inc:{totalPurchases: transaction.totalCash,  totalDebit: transaction.debitCash}

  createNewReceiptCashOfCustomSale: (customerId, debtCash, description)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customer = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
        customSale = Schema.customSales.findOne({buyer: customer._id},{sort: {'version.createdAt': -1}})
        option =
          merchant    : profile.currentMerchant
          warehouse   : profile.currentWarehouse
          creator     : profile.user
          owner       : customer._id
          latestSale  : customSale._id if customSale
          group       : 'customSale'
          totalCash   : debtCash

        if debtCash > 0
          option.description = description ? 'Thu Tiền'
          option.receivable  = true

          incCustomerOption = {
            debtBalance   : -debtCash
            customSaleDebt: -debtCash
            customSalePaid: debtCash
          }
        else
          option.description = description ? 'Cho Mượn Tiền'
          option.receivable  = false

          incCustomerOption = {
            debtBalance         : -debtCash
            customSaleDebt      : -debtCash
            customSaleTotalCash : -debtCash
          }

        option.debtBalanceChange = debtCash
        option.beforeDebtBalance = customer.customSaleDebt
        option.latestDebtBalance = customer.customSaleDebt + debtCash
        Schema.transactions.insert option
        Schema.customers.update customer._id, $inc: incCustomerOption

  createNewReceiptCashOfSales: (customerId, debtCash, description)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customer = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
        sale = Schema.sales.findOne({buyer: customer._id},{sort: {'version.createdAt': -1}})
        option =
          merchant    : profile.currentMerchant
          warehouse   : profile.currentWarehouse
          creator     : profile.user
          owner       : customer._id
          latestSale  : sale._id if sale
          group       : 'sales'
          totalCash   : debtCash

        if debtCash > 0
          option.description = description ? 'Thu Tiền'
          option.receivable  = true
        else
          option.description = description ? 'Cho Mượn Tiền'
          option.receivable  = false


        option.debtBalanceChange = option.totalCash
        option.beforeDebtBalance = customer.debtBalance
        option.latestDebtBalance = customer.debtBalance - debtCash
        Schema.transactions.insert option

        incCustomerOption = {
          debtBalance: -debtCash
          salePaid   : debtCash
          saleDebt   : -debtCash
        }
        Schema.customers.update customer._id, $inc: incCustomerOption
