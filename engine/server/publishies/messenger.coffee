Meteor.publish "conversationWith", (targetId) ->
  sentToTargets =  { sender: @userId, receiver: targetId }
  sentByTargets =  { sender: targetId, receiver: @userId }
  Schema.messages.find {$or: [sentToTargets, sentByTargets]}

Schema.messages.allow
  insert: -> true
  update: -> true
  remove: -> true