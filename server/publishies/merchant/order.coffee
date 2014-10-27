Meteor.publish 'orders', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.orders.find({
    creator  : myProfile.user,
    merchant : myProfile.currentMerchant,
    warehouse: myProfile.currentWarehouse})

Schema.orders.allow
  insert: -> true
  update: -> true
  remove: -> true