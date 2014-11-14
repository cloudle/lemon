Meteor.publish 'products', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.products.find({warehouse: myProfile.currentWarehouse, availableQuality: {$gt: 0}})

Meteor.publish 'allProducts', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.products.find({warehouse: myProfile.currentWarehouse})

Meteor.publish 'allProductDetails', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.productDetails.find({warehouse: myProfile.currentWarehouse})

Schema.products.allow
  insert: (userId, product) ->
    if Schema.products.findOne({
      merchant    : product.merchant
      warehouse   : product.warehouse
      productCode : product.productCode
      skulls      : product.skulls
    }) then false else true

  update: (userId, product) -> true
  remove: (userId, product) ->
    productInUse = Schema.importDetails.findOne {product: product._id}
    return product.totalQuality == 0 and !productInUse

Schema.productDetails.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.productLosts.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.productGroups.allow
  insert: -> true
  update: -> true
  remove: -> true