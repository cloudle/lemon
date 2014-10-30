#Meteor.publish 'myWarehouse', ->
#  myProfile = Schema.userProfiles.findOne({user: @userId})
#  return [] if !myProfile
#  Schema.warehouses.find({_id: myProfile.currentWarehouse})
#Schema.warehouses.allow
#  insert: -> true
#  update: -> true
#  remove: -> true