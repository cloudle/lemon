Meteor.publish 'myProfile', -> Schema.userProfiles.find({})
Schema.userProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true

Meteor.publish 'myOption', -> Schema.userOptions.find({})
Schema.userOptions.allow
  insert: -> true
  update: -> true
  remove: -> true

Meteor.publish 'mySession', -> Schema.userSessions.find({})
Schema.userSessions.allow
  insert: -> true
  update: -> true
  remove: -> true