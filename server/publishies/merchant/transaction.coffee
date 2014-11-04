Meteor.publish 'availableTransaction', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.transactions.find({
    merchant: myProfile.currentMerchant
    warehouse: myProfile.currentWarehouse
  })

Schema.transactions.allow
  insert: -> true
  update: -> true
  remove: -> true