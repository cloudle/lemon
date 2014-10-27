Meteor.publish 'unreadNotifications', ->
  return [] if !@userId
  Schema.notifications.find {receiver: @userId, seen: false}