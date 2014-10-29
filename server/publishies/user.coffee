Meteor.publish 'myProfile', -> Schema.userProfiles.find({user: @userId})
Schema.userProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true

Meteor.publishComposite 'myMerchantContacts',
  find: ->
    currentProfile = Schema.userProfiles.findOne({user: @userId})
    return [] if !currentProfile
    Schema.userProfiles.find { currentMerchant: currentProfile.currentMerchant }
  children: [
    find: (profile) -> Meteor.users.find {_id: profile.user}
  ,
    find: (profile) -> AvatarImages.find {_id: profile.avatar}
  ]


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