Apps.Merchant.checkSummaryDate = (profile)->
  if profile
    toDate = new Date()
    allMerchant = Schema.merchants.find({$or:[{_id: profile.parentMerchant }, {parent: profile.parentMerchant}]})
    for branch in allMerchant.fetch()
      allTransactions = Schema.transactions.find({
        merchant: branch._id
        'version.createdAt': {$gte: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate())}
#        debtDate: {$gte: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate())}
      })
      option =
        discountDay     : 0
        depositDay      : 0
        debitDay        : 0
        revenueDay      : 0
        cogsDay         : 0
        profitabilityDay: 0

      for transaction in allTransactions.fetch()
        option.depositDay = transaction.depositCash
        option.debitDay   = transaction.debitCash
        option.revenueDay = transaction.totalCash

      Schema.metroSummaries.update({merchant: branch._id},{$set: option})
    Schema.merchantProfiles.update({merchant: profile.parentMerchant}, {$set:{latestCheckSummaryDate: new Date()}})
