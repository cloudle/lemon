lemon.cleanSession = ->
  console.log 'clean session is waiting for implements'

lemon.logout = (redirectUrl = undefined)->
  Meteor.logout()
  lemon.cleanSession()
  Router.go(redirectUrl) if redirectUrl