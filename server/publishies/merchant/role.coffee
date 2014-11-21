isMerchantRole = {group: 'merchant'}

allowModifies = (userId, currentRole) ->
  currentProfile = Schema.userProfiles.findOne({user: userId})
  return false if !currentProfile or !currentRole.parent
  currentProfile.parentMerchant is currentRole.parent

Meteor.publish 'currentMerchantRoles', ->
  currentProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !currentProfile
  Schema.roles.find
    $and: [
      isMerchantRole
    ,
      $or: [{parent: {$exists: false}}, parent: currentProfile.parentMerchant]
    ]
  #({$or: [{group: 'merchant'}, {currentMerchant: currentProfile.currentMerchant}]})

Schema.roles.allow
  insert: (userId, currentRole) -> allowModifies(userId, currentRole)    
  update: (userId, currentRole) -> allowModifies(userId, currentRole)
  remove: (userId, currentRole) -> allowModifies(userId, currentRole)