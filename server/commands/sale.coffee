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
        option = {received: true}
        if currentSale.paymentsDelivery == 1
          option.status = false
          Schema.deliveries.update currentSale.delivery, $set: {status: 1}

        transaction =  Transaction.newBySale(currentSale)
        transactionDetail = TransactionDetail.newByTransaction(transaction)
        Schema.sales.update currentSale._id, $set: option
        #      Notification.saleConfirmByAccounting(@id)
        MetroSummary.updateMetroSummaryBySale(currentSale._id)

      if currentSale.status == currentSale.success == currentSale.received == currentSale.exported == true and currentSale.submitted == currentSale.imported == false and currentSale.paymentsDelivery == 1
        Schema.deliveries.update currentSale.delivery, $set:{status: 6, cashier: profile.user}
        transaction = Schema.transactions.findOne({parent: currentSale._id, merchant: profile.currentMerchant, status: "tracking"})
        debitCash = currentSale.debit

        if transaction.debitCash >= debitCash and transaction.status is 'tracking'
          transactionDebitCash = transaction.debitCash - debitCash
          transactionDepositCash = transaction.depositCash + debitCash

          if transactionDepositCash == transaction.totalCash then status = 'closed' else status = 'tracking'

          option =
            debitCash: transactionDebitCash
            depositCash: transactionDepositCash
            status: status

          Schema.transactions.update transaction._id, $set: option
          Schema.transactionDetails.insert TransactionDetail.new(profile.user, transaction, debitCash)

          if transaction.group is 'sale'
            Schema.sales.update transaction.parent, $set:{
              deposit : transactionDepositCash
              debit   : transactionDebitCash
              status  : false
            }
            MetroSummary.updateMetroSummaryByTransaction(transaction.merchant, debitCash)

    #      Notification.saleAccountingConfirmByDelivery(currentSale._id)

    catch error
      throw new Meteor.Error('confirmReceiveSale', error)