Meteor.publish 'inventories', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.inventories.find({merchant: myProfile.currentMerchant})

Schema.inventories.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.inventoryDetails.allow
  insert: -> true
  update: -> true
  remove: -> true