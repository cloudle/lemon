lemon.cleanSession = ->
  console.log 'clean session is waiting for implements'

lemon.logout = ->
  Meteor.logout()
  lemon.cleanSession()