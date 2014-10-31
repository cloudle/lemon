Meteor.publish 'products', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.products.find({warehouse: myProfile.currentWarehouse, availableQuality: {$gt: 0}})

Schema.products.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.productDetails.allow
  insert: -> true
  update: -> true
  remove: -> true