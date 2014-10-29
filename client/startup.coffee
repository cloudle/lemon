Meteor.startup ->
  Tracker.autorun ->
    if Meteor.userId()
      Apps.myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      Apps.myOption = Schema.userOptions.findOne({user: Meteor.userId()})
      Apps.mySession = Schema.userSessions.findOne({user: Meteor.userId()})