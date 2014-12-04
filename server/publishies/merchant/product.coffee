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

Meteor.publish 'availableProducts', ->
  profile = Schema.userProfiles.findOne({user: @userId})
  return [] if !profile
  Schema.products.find({merchant: profile.currentMerchant})

Meteor.publishComposite 'productManagementData', (productId, currentRecords = 0)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.products.find {_id: productId, merchant: myProfile.currentMerchant}
    children: [
      find: (product) -> Schema.productDetails.find {product: product._id}
      children: [
        find: (productDetail, product) -> Schema.imports.find {_id: productDetail.import}
      ,
        find: (productDetail, product) -> Schema.providers.find {_id: productDetail.provider}
      ]
    ]
  }


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

Schema.expiringProducts.allow
  insert: -> true
  update: -> true
  remove: -> true