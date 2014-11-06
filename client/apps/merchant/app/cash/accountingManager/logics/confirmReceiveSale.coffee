Apps.Merchant.accountingManagerInit.push (scope) ->
  logics.accountingManager.confirmReceiveSale= (currentSale)->
    if currentSale.received == currentSale.imported ==  currentSale.exported == currentSale.submitted == false and currentSale.status == true
#      unless Role.hasPermission(Schema.userProfiles.findOne({user: Meteor.userId()})._id, Apps.Merchant.Permissions) then return
      option = {received: true}
      if currentSale.paymentsDelivery == 1
        option.status = false
        Schema.deliveries.update currentSale.delivery, $set: {status: 1}

      transaction =  Transaction.newBySale(currentSale)
      transactionDetail = TransactionDetail.newByTransaction(transaction)
      #      Notification.saleConfirmByAccounting(@id)
      MetroSummary.updateMetroSummaryBySale(@id)
      Schema.sales.update currentSale._id, $set: option
      console.log 'Kế toán đã nhận tiền.'

    if currentSale.status == currentSale.success == currentSale.received == currentSale.exported == true and currentSale.submitted ==  currentSale.imported == false and currentSale.paymentsDelivery == 1
      console.log 'ok 2'
#      unless Role.hasPermission(Schema.userProfiles.findOne({user: Meteor.userId()})._id, Sky.system.merchantPermissions.cashierDelivery.key) then return
#      userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
#      Schema.deliveries.update currentSale.delivery, $set:{status: 6, cashier: Meteor.userId()}
#      transaction = Transaction.findOne({parent: currentSale._id, merchant: userProfile.currentMerchant, status: "tracking"})
#      debitCash = currentSale.debit
#      transaction.recalculateTransaction(debitCash)
#  #      Notification.saleAccountingConfirmByDelivery(currentSale._id)
