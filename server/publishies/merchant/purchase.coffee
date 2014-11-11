Meteor.publish 'myPurchase', ->
  return [] if !@userId
  Schema.merchantPurchases.find({user: @userId})
