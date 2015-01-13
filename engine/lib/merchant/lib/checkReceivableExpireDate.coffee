Apps.Merchant.checkReceivableExpireDate = (profile, value)->
  if profile
    timeOneDay  = 86400000
    tempDate    = new Date
    currentDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
    receivableDate  = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate() - value)

    allWarehouse = Schema.warehouses.find({parentMerchant: profile.parentMerchant}).fetch()
    transactions = Schema.transactions.find({$and:[
      {warehouse: {$in:_.pluck(allWarehouse, '_id')}}
      {debtDate:{$lt: receivableDate}}
#      {'version.createdAt':{$lte: receivableDate}}
      {receivable: true }
      {dueDay: { $exists: false }}
    ]}).fetch()

    customers = Schema.customers.find({_id: {$in: _.union(_.pluck(transactions, 'owner'))} }).fetch()
    for transaction in transactions
      transactionCreateDate = new Date(transaction.debtDate.toDateString())
      currentTransaction =
        customerName : _.findWhere(customers, {_id: transaction.owner})?.name ? "Bạn"
        day          : (currentDate.getTime() - transactionCreateDate.getTime())/timeOneDay - value
      Notification.receivableExpire(currentTransaction, profile)
    Schema.branchProfiles.update({merchant: profile.parentMerchant}, {$set:{latestCheckReceivable: new Date()}})

Apps.Merchant.checkExpireDateCreateTransaction = (profile, transactionId, value)->
  if profile
    timeOneDay  = 86400000
    tempDate    = new Date()
    currentDate = new Date(tempDate.toDateString())
    receivableDate  = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate() - value)

    if transaction = Schema.transactions.findOne({_id: transactionId, debtDate:{$lt: receivableDate}})
      transactionCreateDate = new Date(transaction.debtDate.toDateString())
      currentTransaction =
        _id          : transaction._id
        customerName : Schema.customers.findOne(transaction.owner)?.name ? "Bạn"
        day          : (currentDate.getTime() - transactionCreateDate.getTime())/timeOneDay - value
      Notification.receivableExpire(currentTransaction, profile)
