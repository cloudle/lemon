Meteor.publish 'myPurchase', ->
  return [] if !@userId
  console.log @userId
  profile = Schema.userProfiles.findOne({user: @userId})

  return [] if !profile
  console.log profile

  Schema.merchantPurchases.find({merchant: profile.currentMerchant})