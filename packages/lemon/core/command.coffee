exceptions = ['topPanelMinimize', 'currentCommentPosition']

lemon.cleanSession = ->
  console.log 'cleaning sessions'
  delete Session.keys[key] for key, obj of Session.keys when !_.contains(exceptions, key)

lemon.logout = (redirectUrl = '/')->
  Meteor.logout()
  lemon.cleanSession()
  Meteor.setTimeout ->
    Router.go(redirectUrl) if redirectUrl
  , 1000