Schema.add 'transactionDetails', "TransactionDetail", class TransactionDetail
  @newByTransaction: (transaction)->
    option=
      merchant    : transaction.merchant
      warehouse   : transaction.warehouse
      creator     : transaction.creator
      transaction : transaction._id
      totalCash   : transaction.totalCash
      depositCash : transaction.depositCash
      debitCash   : transaction.debitCash
    option._id = Schema.transactionDetails.insert option
    option

  @newByUser: (transactionId, depositCash, paymentDate)->
    myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    transaction  = Schema.transactions.findOne({_id: transactionId, merchant: myProfile.currentMerchant})
    if myProfile and transaction and depositCash > 0 and transaction.debitCash >= depositCash
      option =
        merchant    : transaction.merchant
        warehouse   : transaction.warehouse
        creator     : myProfile.user
        transaction : transaction._id
        totalCash   : transaction.debitCash
        depositCash : depositCash
        debitCash   : transaction.debitCash - depositCash

      option.paymentDate = paymentDate if paymentDate
      Schema.transactionDetails.insert option
      Schema.transactions.update transaction._id, $inc:{depositCash: depositCash, debitCash: -depositCash}
      return true

  @new: (creator, transaction, depositCash, paymentDate)->
    option =
      merchant    : transaction.merchant
      warehouse   : transaction.warehouse
      creator     : creator
      transaction : transaction._id
      totalCash   : transaction.debitCash
      depositCash : depositCash
      debitCash   : transaction.debitCash - depositCash

    option.paymentDate = paymentDate if paymentDate



