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

Meteor.publishComposite 'availableProducts', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !profile
      Schema.products.find({merchant: profile.currentMerchant})
    children: [
      find: (product) -> Schema.productUnits.find {product: product._id}
    ]
  }

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
        children: [
          find: (currentImport, product) -> Schema.distributors.find {_id: currentImport.distributor}
        ]
      ,
        find: (productDetail, product) -> if product.basicDetailModeEnabled then EmptyQueryResult else Schema.saleDetails.find {productDetail: productDetail._id}
        children: [
          find: (saleDetail, product) -> Schema.sales.find {_id: saleDetail.sale}
          children: [
            find: (sale, product) -> Schema.customers.find {_id: sale.buyer}
          ]
        ]
      ,
        find: (productDetail, product) -> Schema.providers.find {_id: productDetail.provider}
      ]
    ,
      find: (product) -> if product.basicDetailModeEnabled then Schema.saleDetails.find {product: product._id} else EmptyQueryResult
      children: [
        find: (saleDetail, product) -> Schema.sales.find {_id: saleDetail.sale}
        children: [
          find: (sale, product) -> Schema.customers.find {_id: sale.buyer}
        ]
      ]
    ,
      find: (product) -> Schema.returnDetails.find {product: product._id}
    ]
  }


Schema.products.allow
  insert: (userId, product) ->
    existedQuery = {merchant: product.merchant, warehouse: product.warehouse, name: product.name}
    existedQuery.productCode = product.productCode if product.productCode
    existedQuery.skulls      = product.skulls if product.skulls
    if Schema.products.findOne existedQuery then false else true

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

Schema.productUnits.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.buildInProductUnits.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.buildInProducts.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.branchProducts.allow
  insert: -> true
  update: -> true
  remove: -> true
    
Schema.merchantProducts.allow
  insert: -> true
  update: -> true
  remove: -> true