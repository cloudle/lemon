Meteor.methods
  deleteTransaction: (id)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if !profile then throw 'Không tìm thấy profile'

#      permission = Role.hasPermission(profile._id, Apps.Merchant.Permissions.transactionManagement.key)
#      if permission is false then throw 'Bạn không có quyền thực hiên.'

      transaction = Schema.transactions.findOne({_id: id, merchant: profile.currentMerchant})
      if !transaction then throw 'Không tìm thấy transaction'

      transactionDetails = Schema.transactionDetails.find({transaction: transaction._id})
      if transactionDetails.count() > 1 then throw 'Không thể xóa transaction khi thêm mới transactionDetails '

      if transaction.allowDelete is true and transaction.group is 'customer'
        Schema.transactions.remove transaction._id
        Schema.transactionDetails.remove {transaction: transaction._id}
        MetroSummary.updateMetroSummaryByDestroyTransaction(transaction.merchant, transaction.debitCash)
        Schema.customers.update transaction.owner, $inc:{totalPurchases: -transaction.totalCash, totalDebit: -transaction.debitCash}
        Schema.notifications.remove {product: transaction._id}

        return true
      else throw 'Xóa transaction không thành công'
          
    catch error
      throw new Meteor.Error('deleteTransaction', error)


  addTransactionDetail: (transactionId, depositCash, paymentDate)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if !profile then throw 'Không tìm thấy profile'

#      permission = Role.hasPermission(profile._id, Apps.Merchant.Permissions.transactionManagement.key)
#      if permission is false then throw 'Bạn không có quyền thực hiên.'

      transaction = Schema.transactions.findOne({_id: transactionId, merchant: profile.currentMerchant})
      if !transaction then throw 'Không tìm thấy transaction'
      if transaction.debitCash < depositCash then throw 'Tiền trả lớn hơn tiền thiếu.'
      if depositCash <= 0 then throw 'Tiền trả lớn hơn 0.'

      if Schema.transactionDetails.insert TransactionDetail.new(profile.user, transaction, depositCash, paymentDate)
        Schema.transactions.update transaction._id, $inc:{depositCash: depositCash, debitCash: -depositCash}
        if transaction.debitCash is depositCash
          Schema.transactions.update transaction._id, $set:{status:'closed', dueDay: new Date()}
        if transaction.group is 'customer' and transaction.allowDelete is true
          Schema.transactions.update transaction._id, $set: {allowDelete: false}
        if transaction.group is 'sale'
          Schema.sales.update transaction.parent, $inc: {deposit: depositCash, debit: -depositCash}
        if transaction.group is 'sale' or transaction.group is 'customer'
          Schema.customers.update transaction.owner, $inc:{totalDebit: -depositCash}

        MetroSummary.updateMetroSummaryByTransaction(profile.currentMerchant, depositCash)
      else throw 'Thêm trả nợ không thành công'

    catch error
      throw new Meteor.Error('addTransactionDetail', error)

