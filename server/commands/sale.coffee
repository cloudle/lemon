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

      #      permission = Role.hasPermission(profile._id, Apps.Merchant.Permissions.transactionManagement.key)
      #      if permission is false then throw 'Bạn không có quyền thực hiên.'

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
        Meteor.call 'createNewReceiptCashOfCustomer', currentSale.buyer, currentSale.deposit
        Meteor.call 'saleConfirmByAccounting', profile, currentSale._id


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