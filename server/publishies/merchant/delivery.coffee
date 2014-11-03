Meteor.publish 'availableDeliveries', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.deliveries.find({
    merchant: myProfile.currentMerchant
    warehouse: myProfile.currentWarehouse
  })

Schema.deliveries.allow
  insert: -> true
  update: -> true
  remove: -> true