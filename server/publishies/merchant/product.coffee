Meteor.publish 'productSales', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.products.find({warehouse: myProfile.currentWarehouse, availableQuality: {$gt: 0}},
    {fields: {
      availableQuality: 1,
      name: 1,
      productCode: 1,
      provider: 1,
      skulls: 1,
      price: 1,
      'version.updateAt': 1}})

Schema.products.allow
  insert: -> true
  update: -> true
  remove: -> true