Schema.add 'messages', class Messenger
  @say: (message, receiver) ->
    zone.run =>
      @schema.insert
        sender: Meteor.userId()
        receiver: receiver
        message: message

  @read: (messageId) ->
    zone.run =>
      currentMessage = @schema.findOne(messageId)
      @schema.update(messageId, {$push: {reads: Meteor.userId()}}) if currentMessage