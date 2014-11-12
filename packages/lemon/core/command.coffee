lemon.cleanSession = ->
  lemon.GlobalSubscriberCache.reset()
  console.log 'clean session is waiting for implements'

lemon.logout = (redirectUrl = undefined)->
  Meteor.logout()
  lemon.cleanSession()
  Meteor.setTimeout ->
    Router.go(redirectUrl) if redirectUrl
  , 1000
