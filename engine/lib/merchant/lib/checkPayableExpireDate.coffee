Apps.Merchant.checkPayableExpireDate = (profile, value)->
  if profile
    timeOneDay  = 86400000
    tempDate    = new Date
    currentDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
    payableDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate() - value)

    allWarehouse = Schema.warehouses.find({parentMerchant: profile.parentMerchant}).fetch()
    transactions = Schema.transactions.find({$and:[
      {warehouse: {$in:_.pluck(allWarehouse, '_id')}}
      {debtDate:{$lte: payableDate}}
#      {'version.createdAt':{$lte: payableDate}}
      {receivable: false }
      {dueDay: { $exists: false }}
    ]}).fetch()

    distributors = Schema.distributors.find({_id: {$in: _.union(_.pluck(transactions, 'owner'))} }).fetch()
    for transaction in transactions
      transactionCreateDate = new Date(transaction.version.createdAt.getFullYear(), transaction.version.createdAt.getMonth(), transaction.version.createdAt.getDate())
      currentTransaction =
        companyName : _.findWhere(distributors, {_id: transaction.owner})?.name ? "Bạn"
        day         : (currentDate.getTime() - transactionCreateDate.getTime())/timeOneDay - value
      Notification.payableExpire(currentTransaction, profile)
    Schema.branchProfiles.update({merchant: profile.parentMerchant}, {$set:{latestCheckPayable: new Date()}})
