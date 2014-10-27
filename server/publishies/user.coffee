Meteor.publish 'myProfile', -> Schema.userProfiles.find({user: @userId})
Schema.userProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true

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