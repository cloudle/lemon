Meteor.publish 'myProfile', -> Schema.userProfiles.find({user: @userId})
Schema.userProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true

Meteor.publish 'currentMerchantContacts', ->
  currentProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !currentProfile
  profiles = Schema.userProfiles.find {currentMerchant: currentProfile.currentMerchant},
    fields: {_id: 1, user: 1, fullName: 1, avatar: 1}
  userIds = profiles.map (profile) -> profile.user
  users = Meteor.users.find {_id: {$in: userIds}},
    fields: {_id: 1, emails: 1, status: 1}

  [profiles, users]

Meteor.publish 'myOption', -> Schema.userOptions.find({user: @userId})
Schema.userOptions.allow
  insert: -> true
  update: -> true
  remove: -> true

Meteor.publish 'mySession', -> Schema.userSessions.find({user: @userId})
Schema.userSessions.allow
  insert: -> true
  update: -> true
  remove: -> true

