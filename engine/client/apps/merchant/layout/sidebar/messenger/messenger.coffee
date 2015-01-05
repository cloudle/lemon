scope = logics.messenger

lemon.defineWidget Template.messenger,
  currentMessages: -> scope.messengerDeps?.depend(); scope.currentMessages
  messageClass: -> if @sender is Meteor.userId() then 'me' else 'friend'
  firstName: ->
    profile = Schema.userProfiles.findOne({user: Session.get('currentChatTarget')})
    Helpers.firstName(profile.fullName ? Meteor.users.findOne(profile.user)?.emails[0].address)
  avatarUrl: ->
    profile = Schema.userProfiles.findOne({user: Session.get('currentChatTarget')})
    if profile.avatar then AvatarImages.findOne(profile.avatar)?.url() else undefined
  friendMessage: -> @sender isnt Meteor.userId()
  hasTarget: -> Session.get('currentChatTarget') isnt undefined

  targetName: ->
    profile = Schema.userProfiles.findOne({user: Session.get('currentChatTarget')})
    profile?.fullName ? Meteor.users.findOne(profile.user)?.emails[0].address

  created: -> Apps.setup(scope, Apps.Merchant.messengerInit, 'messenger')
  rendered: ->
    thisTime = Date.now()

    scope.messengerDeps = new Tracker.Dependency

    scope.initTracker = Tracker.autorun ->
      Apps.setup(scope, Apps.Merchant.messengerReactive)

    scope.incomingObserver = scope.allMessages.observeChanges
      added: (id, instance) -> scope.playSoundIfNecessary(instance, thisTime)

    $(".conversation-wrapper").slimScroll({size: '3px', color: '#909090', railOpacity: 1})
    $("body").on "DOMNodeInserted", ".conversation-wrapper", (e) ->
      $(".conversation-wrapper").slimScroll({scrollTo: '99999px'})

  destroyed: ->
    scope.initTracker.stop()
    scope.incomingObserver.stop()
    $("body").off("DOMNodeInserted")

  events:
    "keypress .input-wrapper input": ->
      $element = $(event.target)
      message = $element.val()
      if event.which is 13 and message.length > 0 and Session.get('currentChatTarget')
        Messenger.say message, Session.get('currentChatTarget')
        $element.val('')