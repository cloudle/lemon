sentByMe = {sender: Meteor.userId()}
sentToMe = {receiver: Meteor.userId()}

Apps.Merchant.messengerInit.push (scope) ->
  createjs.Sound.registerSound({src:"/sounds/incoming.mp3", id: "sound"})

  scope.allMessages = Schema.messages.find({$or: [sentByMe, sentToMe]})
  scope.playSoundIfNecessary = (instance, timeHook) ->
    if instance.version?.createdAt > timeHook
      createjs.Sound.play("sound")
      console.log "pong..."

Apps.Merchant.messengerReactive.push (scope) ->
  if target = Session.get('currentChatTarget')
    scope.messengerDeps.changed()
    Meteor.subscribe("conversationWith", target)
    sentByTarget = { sender: target }
    sentToTarget = { receiver: target }
    scope.currentMessages = Schema.messages.find {$or: [sentByTarget, sentToTarget]}, {sort: {"version.createdAt": 1}}