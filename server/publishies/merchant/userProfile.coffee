Meteor.publish 'userProfiles', -> Schema.userProfiles.find {}
Schema.userProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true