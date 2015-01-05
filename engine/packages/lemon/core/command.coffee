lemon.sessionCleanList = ['registerAccountValid', 'registerSecretValid', 'loginValid',
                          'allowCreateStaffAccount',
                          'currentChatTarget', 'currentAppName', 'myProfile', 'mySession']

lemon.listSession = -> console.log key for key, obj of Session.keys

lemon.cleanSession = ->
  console.log 'cleaning sessions'
  delete Session.keys[key] for key, obj of Session.keys when _.contains(lemon.sessionCleanList, key)

lemon.logout = (redirectUrl = '/')->
  Meteor.logout()
  Apps.setupHistories = []
  lemon.cleanSession()
  Meteor.setTimeout ->
    Router.go(redirectUrl) if redirectUrl
  , 1000