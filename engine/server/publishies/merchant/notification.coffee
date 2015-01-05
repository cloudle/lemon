Meteor.publish 'unreadNotifications', ->
  return [] if !@userId
  Schema.notifications.find {receiver: @userId, seen: false}


Schema.notifications.allow
  insert: -> true
  update: -> true
  remove: -> true