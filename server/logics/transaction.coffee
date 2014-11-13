Meteor.methods
  deleteTransaction: (id)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      permission = Role.hasPermission(profile._id, Apps.Merchant.Permissions.transactionManagement.key)
      transaction = Schema.transactions.findOne({_id: id, merchant: profile.currentMerchant})
      if transaction and permission
        if Schema.transactionDetails.find({transaction: transaction._id}).count() is 0
          Schema.transactions.remove transaction._id
          return true

  addTransactionDetail: (transactionId, depositCash, paymentDate)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      permission = Role.hasPermission(profile._id, Apps.Merchant.Permissions.transactionManagement.key)
      transaction = Schema.transactions.findOne({_id: transactionId, merchant: profile.currentMerchant})
      if transaction and permission and transaction.debitCash >= depositCash
        TransactionDetail.newByUser(transactionId, depositCash, paymentDate)
        return true