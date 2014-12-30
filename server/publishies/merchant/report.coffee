Meteor.publishComposite 'merchantReportData', (branchIds, startDate = new Date(), toDate = new Date())->
  self = @
  if toDate > startDate
    startDate = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate())
    toDate    = new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate() + 1)
  else
    startDate = new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate())
    toDate    = new Date(startDate.getFullYear(), startDate.getMonth(), startDate.getDate() + 1)

  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !profile
      if branchIds is undefined then branchIds = profile.currentMerchant

      if typeof branchIds is "string"
        if branchIds is profile.parentMerchant then Schema.merchants.find {_id: branchIds}
        else  Schema.merchants.find {_id: branchIds, parent: profile.parentMerchant}

      else if typeof branchIds is "object"
        if branchIds.length > 0
          if _.contains(branchIds, profile.parentMerchant)
            branchIds = _.without(branchIds, profile.parentMerchant)
            Schema.merchants.find({$or:[{_id: profile.parentMerchant}, {_id:{$in:branchIds}, parent: profile.parentMerchant}]})
          else
            Schema.merchants.find({$or:[{_id:{$in:branchIds}}, {parent: profile.parentMerchant}]})

      else
        EmptyQueryResult

    children: [
      find: (branch) -> Schema.imports.find {
        $and: [
          {merchant: branch._id}
          {finish: true}
          {submitted: true}
          {'version.createdAt': {$gt: startDate}}
          {'version.createdAt': {$lt: toDate}}
        ]
      }
      children: [
        find: (currentImport, branch) -> Schema.distributors.find {_id: currentImport.distributor}
      ]
    ,
      find: (branch) -> Schema.sales.find {
        $and: [
          {merchant: branch._id}
          {'version.createdAt': {$gt: startDate}}
          {'version.createdAt': {$lt: toDate}}
        ]
      }
      children: [
        find: (sale, branch) -> Schema.customers.find {_id: sale.buyer}
      ]
    ,
      find: (branch) -> Schema.returns.find {
        $and: [
          {merchant: branch._id}
          {status  : 2}
          {'version.createdAt': {$gt: startDate}}
          {'version.createdAt': {$lt: toDate}}
        ]
      }
    ,
      find: (branch) -> Schema.transactions.find {
        $and: [
          { merchant: branch._id }
          { debtBalanceChange: { $exists: true }}
          { beforeDebtBalance: { $exists: true }}
          { latestDebtBalance: { $exists: true }}
          { debtDate: {$gt: startDate} }
          { debtDate: {$lt: toDate} }
        ]
      }
    ]
  }