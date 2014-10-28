Meteor.publish 'currentMerchantRoles', ->
  currentProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !currentProfile
  Schema.roles.find({$or: [{group: 'merchant'}, {currentMerchant: currentProfile.currentMerchant}]})

Schema.roles.allow
  insert: -> true
  update: -> true
  remove: -> true