Meteor.publish 'productSales', -> Schema.products.find {}
Schema.products.allow
  insert: -> true
  update: -> true
  remove: -> true