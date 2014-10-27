Meteor.publish 'messengerContacts', ->
  currentProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !currentProfile
  profiles = Schema.userProfiles.find {currentMerchant: currentProfile.currentMerchant},
    fields: {_id: 1, user: 1, fullName: 1, avatar: 1}
  userIds = profiles.map (profile) -> profile.user
  users = Meteor.users.find {_id: {$in: userIds}},
    fields: {_id: 1, emails: 1, status: 1}

  [profiles, users]

Meteor.publish 'unreadMessages', ->
  return [] if !@userId
  Schema.messages.find {receiver: @userId, reads: {$ne: @userId}}