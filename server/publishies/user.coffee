Meteor.publish 'myProfile', -> Schema.userProfiles.find({user: @userId})

Meteor.publishComposite 'myMerchantProfiles', ->
  self = @
  return {
    find: ->
      currentProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !currentProfile
      Schema.userProfiles.find {currentMerchant: currentProfile.currentMerchant}
    children: [
      find: (profile) -> Meteor.users.find {_id: profile.user}
    ,
      find: (profile) -> AvatarImages.find {_id: profile.avatar}
    ]
  }

Meteor.publish 'myOption', -> Schema.userOptions.find({user: @userId})

Schema.userProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.userOptions.allow
  insert: -> true
  update: -> true
  remove: -> true

Meteor.publish 'mySession', -> Schema.userSessions.find({user: @userId})
Schema.userSessions.allow
  insert: -> true
  update: -> true
  remove: -> true