Template.registerHelper 'sessionGet', (name) -> Session.get(name)
Template.registerHelper 'authenticated', (name) -> Meteor.userId() isnt null

Template.registerHelper 'metroUnLocker', (context) ->  if context < 1 then 'locked'