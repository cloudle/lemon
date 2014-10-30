Meteor.startup ->
  Tracker.autorun ->
    if Meteor.userId()
      console.log 'Rerun profile startup!'
      Session.set('myProfile', Schema.userProfiles.findOne({user: Meteor.userId()}))
      Session.set('myOption', Schema.userOptions.findOne({user: Meteor.userId()}))
      Session.set('mySession', Schema.userSessions.findOne({user: Meteor.userId()}))