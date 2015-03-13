updateSale        = (saleId, option)        -> Schema.sales.update saleId, $set: option
updateCustomer    = (customerId, option)    -> Schema.customers.update customerId, $inc: option
updateTransaction = (transactionId, option) -> Schema.transactions.update transactionId, $set: option

newTransactionAndDetail = (currentSale)->
  transaction       = Transaction.newBySale(currentSale)
  transactionDetail = TransactionDetail.newByTransaction(transaction)

Meteor.methods
  confirmReceiveSale: (id)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if !profile then throw 'Không tìm thấy profile'

      transactionManager = Role.hasPermission(profile._id, Apps.Merchant.TempPermissions.transactionManager.key)
      if transactionManager is false then throw "Bạn không có phân quyền."

      currentSale = Schema.sales.findOne({_id: id, merchant: profile.currentMerchant})
      if !currentSale then throw 'Không tìm thấy phiếu bán hàng'

      if currentSale.received == currentSale.imported == currentSale.exported == currentSale.submitted == false and currentSale.status == true
        saleOption     = {received: true}
        customerOption = {totalPurchases: currentSale.finalPrice, totalDebit: currentSale.debit}
        if currentSale.paymentsDelivery == 1
          saleOption.status = false
          Schema.deliveries.update currentSale.delivery, $set: {status: 1}

        newTransactionAndDetail(currentSale)
        updateSale(currentSale._id, saleOption)
        updateCustomer(currentSale.buyer, customerOption)
        MetroSummary.updateMetroSummaryBySale(currentSale._id)
        Meteor.call 'updateMetroSummaryBy', 'createSale', currentSale._id, currentSale.merchant

        if currentSale.deposit > 0
          Meteor.call 'createNewReceiptCashOfSales', currentSale.buyer, currentSale.deposit, 'Tiền Mặt'
#        Meteor.call 'saleConfirmByAccounting', profile, currentSale._id


      if currentSale.status == currentSale.success == currentSale.received == currentSale.exported == true and currentSale.submitted == currentSale.imported == false and currentSale.paymentsDelivery == 1
        Schema.deliveries.update currentSale.delivery, $set:{status: 6, cashier: profile.user}
        transaction = Schema.transactions.findOne({parent: currentSale._id, merchant: profile.currentMerchant, status: "tracking"})
        debitCash = currentSale.debit

        if transaction.debitCash >= debitCash and transaction.status is 'tracking'
          transactionDebitCash   = transaction.debitCash - debitCash
          transactionDepositCash = transaction.depositCash + debitCash
          if transactionDepositCash == transaction.totalCash then status = 'closed' else status = 'tracking'

          transactionOption =
            status      : status
            debitCash   : transactionDebitCash
            depositCash : transactionDepositCash
          updateTransaction(transaction._id, transactionOption)
          Schema.transactionDetails.insert TransactionDetail.new(profile.user, transaction, debitCash)

          if transaction.group is 'sale'
            customerOption = {totalDebit: -debitCash}
            updateCustomer(transaction.owner, customerOption)

            saleOption =
              deposit : transactionDepositCash
              debit   : transactionDebitCash
              status  : false
            updateSale(transaction.parent, saleOption)
            Meteor.call 'saleAccountingConfirmByDelivery', profile, currentSale._id
            MetroSummary.updateMetroSummaryByTransaction(transaction.merchant, debitCash)
    catch error
      throw new Meteor.Error('confirmReceiveSale', error)

  customerToSales: (customer, profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      customer = Schema.customers.findOne({_id: customer._id ,parentMerchant: profile.parentMerchant}) if customer.parentMerchant != profile.parentMerchant

      if customer
        orderFound = Schema.orders.findOne({creator: userId, buyer: customer._id, merchant: profile.currentMerchant, status: 0}, {sort: {'version.createdAt': -1}})
        if !orderFound then orderFound = Order.createdNewBy(customer, profile)
        Schema.userSessions.update {user: userId}, {$set:{currentOrder: orderFound._id}}

      else throw 'Không tìm thấy khách hàng'

    catch error
      throw new Meteor.Error('customerToSales', error)

  customerToReturns: (customer)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      if profile = Schema.userProfiles.findOne({user: userId})
        if customer is undefined || customer.parentMerchant != profile.parentMerchant
          customer = Schema.customers.findOne({_id: customer._id, parentMerchant: profile.parentMerchant})
        if customer
          returnFound = Schema.returns.findOne({
            merchant: profile.currentMerchant
            creator : userId
            customer: customer._id
            status  : 0
            returnMethods: 0
          }, {sort: {'version.createdAt': -1}})
          if !returnFound then returnFound = Return.createByCustomer(customer, profile)
          Schema.userSessions.update {user: userId}, {$set:{currentCustomerReturn: returnFound._id}} if returnFound
        else throw 'Không tìm thấy khách hàng'
    catch error
      throw new Meteor.Error('customerToReturns', error)

  reUpdateOrderCode: (profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      Schema.customers.find().forEach(
#      Schema.customers.find({parentMerchant: profile.parentMerchant}).forEach(
        (customer)->
          orderCode = '0000'
          Schema.sales.find({buyer: customer._id},{sort: {'version.createdAt': 1}}).forEach(
            (sale)->
              orderCode = Helpers.orderCodeCreate(orderCode)
              Schema.sales.update sale._id, $set:{orderCode: orderCode}
          )
          Schema.customers.update customer._id, $set:{billNo: orderCode}
      )
      console.log 'reUpdateOrderCode. -->Ok'

    catch error
      throw new Meteor.Error('reUpdateOrderCode', error)
