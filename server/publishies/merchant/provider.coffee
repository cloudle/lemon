Meteor.publish 'providers', -> Schema.providers.find {}
Schema.providers.allow
  insert: -> true
  update: -> true
  remove: -> true