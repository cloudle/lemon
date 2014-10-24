Meteor.publish 'sales', -> Schema.sales.find {}
Schema.sales.allow
  insert: -> true
  update: -> true
  remove: -> true