Meteor.publish 'myPurchase', ->
  return [] if !@userId
  profile = Schema.userProfiles.findOne({user: @userId})
  return [] if !profile
  Schema.merchantPurchases.find({merchant: profile.currentMerchant})

Schema.merchantPurchases.allow
  insert: -> true
  update: -> true
  remove: -> true