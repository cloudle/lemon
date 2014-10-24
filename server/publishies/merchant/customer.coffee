Meteor.publish 'customers', -> Schema.customers.find {}
Schema.customers.allow
  insert: -> true
  update: -> true
  remove: -> true