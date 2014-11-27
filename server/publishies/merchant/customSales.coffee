Meteor.publishComposite 'availableCustomSaleOf', (customerId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.customSales.find {buyer: customerId, parentMerchant: myProfile.parentMerchant}
    children: [
      find: (customSale) -> Schema.customSaleDetails.find {customSale: customSale._id}
    ,
      find: (customSale) -> Schema.transactions.find {latestSale: customSale._id}
    ]
  }

Schema.customSales.allow
  insert: (userId, customSale) -> true
  update: (userId, customSale) -> true
  remove: (userId, customSale) -> true


Schema.customSaleDetails.allow
  insert: (userId, customSaleDetail) -> true
  update: (userId, customSaleDetail) -> true
  remove: (userId, customSaleDetail) -> true
