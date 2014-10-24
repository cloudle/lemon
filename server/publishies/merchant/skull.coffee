Meteor.publish 'skulls', -> Schema.skulls.find {}
Schema.skulls.allow
  insert: -> true
  update: -> true
  remove: -> true