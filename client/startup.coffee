Meteor.startup ->
  Tracker.autorun ->
    if Meteor.userId()
      Session.set('myProfile', Schema.userProfiles.findOne({user: Meteor.userId()}))
      Session.set('myOption', Schema.userOptions.findOne({user: Meteor.userId()}))
      Session.set('mySession', Schema.userSessions.findOne({user: Meteor.userId()}))