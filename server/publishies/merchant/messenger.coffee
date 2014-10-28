Meteor.publish 'unreadMessages', ->
  return [] if !@userId
  Schema.messages.find {receiver: @userId, reads: {$ne: @userId}}