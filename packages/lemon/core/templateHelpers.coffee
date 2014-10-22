Template.registerHelper 'sessionGet', (name) -> Session.get(name)
Template.registerHelper 'authenticated', (name) -> Meteor.userId() isnt null