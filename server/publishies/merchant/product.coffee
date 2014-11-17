Meteor.publish 'products', ->
  profile = Schema.userProfiles.findOne({user: @userId})
  return [] if !profile
  Schema.products.find({warehouse: profile.currentWarehouse, availableQuality: {$gt: 0}})

Meteor.publish 'allProducts', ->
  profile = Schema.userProfiles.findOne({user: @userId})
  return [] if !profile
  Schema.products.find({warehouse: profile.currentWarehouse})

Meteor.publish 'allProductDetails', ->
  profile = Schema.userProfiles.findOne({user: @userId})
  return [] if !profile
  Schema.productDetails.find({warehouse: profile.currentWarehouse})


Meteor.publish 'productDetails', (productId) ->
  profile = Schema.userProfiles.findOne({user: @userId})
  currentProduct = Schema.products.findOne({_id: productId, merchant: profile.currentMerchant})
  return [] if !profile or !currentProduct
  Schema.productDetails.find {product: currentProduct._id}


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