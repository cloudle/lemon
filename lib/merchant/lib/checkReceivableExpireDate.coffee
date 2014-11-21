Apps.Merchant.checkReceivableExpireDate = (profile, value)->
  if profile
    console.log 'active checkReceivableExpireDate'
    timeOneDay  = 86400000
    tempDate    = new Date
    currentDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
    receivableDate  = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate() - value)

    allWarehouse = Schema.warehouses.find({parentMerchant: profile.parentMerchant}).fetch()
    transactions = Schema.transactions.find({$and:[
      {warehouse: {$in:_.pluck(allWarehouse, '_id')}}
      {debtDate:{$lte: receivableDate}}
#      {'version.createdAt':{$lte: receivableDate}}
      {receivable: true }
      {dueDay: { $exists: false }}
    ]}).fetch()

    customers = Schema.customers.find({_id: {$in: _.union(_.pluck(transactions, 'owner'))} }).fetch()
    for transaction in transactions
      transactionCreateDate = new Date(transaction.version.createdAt.getFullYear(), transaction.version.createdAt.getMonth(), transaction.version.createdAt.getDate())
      currentTransaction =
        customerName : _.findWhere(customers, {_id: transaction.owner}).name
        day          : (currentDate.getTime() - transactionCreateDate.getTime())/timeOneDay - value
      Notification.receivableExpire(currentTransaction, profile)
    Schema.merchantProfiles.update({merchant: profile.parentMerchant}, {$set:{latestCheckReceivable: new Date()}})
