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

Meteor.publishComposite 'availableBranchProducts', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant}) if profile
      return EmptyQueryResult if !metroSummary
      Schema.products.find({_id:{$in: metroSummary.productList ? []}, merchant: profile.currentMerchant})
    children: [
      find: (product) -> Schema.buildInProducts.find {_id: product.buildInProduct}
    ]
  }

Meteor.publishComposite 'availableUnBranchProducts', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant}) if profile
      return EmptyQueryResult if !metroSummary
      Schema.products.find({_id:{$nin: metroSummary.productList ? []}, merchant: profile.currentMerchant})
    children: [
      find: (product) -> Schema.buildInProducts.find {_id: product.buildInProduct}
    ]
  }

Meteor.publishComposite 'availableProducts', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !profile
      Schema.products.find({merchant: profile.currentMerchant})
    children: [
      find: (product) -> Schema.buildInProducts.find {_id: product.buildInProduct}
      children: [
        find: (buildInProduct, product) -> Schema.buildInProductUnits.find {buildInProduct: buildInProduct._id}
      ]
    ,
      find: (product) -> Schema.branchProductSummaries.find {product: product._id}
    ,
      find: (product) -> Schema.productUnits.find  {product: product._id, merchant: product.merchant}
      children: [
        find: (productUnit, product) -> Schema.branchProductUnits.find {productUnit: productUnit._id}
      ]
    ]
  }

Meteor.publishComposite 'availableGeraProducts', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !profile
      Schema.buildInProducts.find()
  }

Meteor.publishComposite 'productManagementData', (productId = null, currentRecords = 0)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
#      session = Schema.userSessions.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile #or !session
#      productId = session.currentProductManagementSelection if !productId
      Schema.products.find {_id: productId, merchant: myProfile.currentMerchant}
    children: [
      find: (product) -> Schema.buildInProducts.find {_id: product.buildInProduct}
      children: [
        find: (buildInProduct, product) -> Schema.buildInProductUnits.find {buildInProduct: buildInProduct._id}
      ]
    ,
      find: (product) -> Schema.branchProductSummaries.find {product: product._id}
    ,
      find: (product) -> Schema.productUnits.find  {product: product._id, merchant: product.merchant}
      children: [
        find: (productUnit, product) -> Schema.branchProductUnits.find {productUnit: productUnit._id}
      ]
    ,
      find: (product) -> Schema.productDetails.find {product: product._id}
      children: [
        find: (productDetail, product) -> Schema.partnerSaleDetails.find {productDetail: $elemMatch: {productDetail: productDetail._id}}
        children: [
          find: (partnerSaleDetail, product) -> Schema.partnerSales.find {_id: partnerSaleDetail.partnerSales}
          children: [
            find: (partnerSale, product) -> Schema.partners.find {_id: partnerSale.partner}
          ]
        ]
      ,
        find: (productDetail, product) -> Schema.imports.find {_id: productDetail.import}
        children: [
          find: (currentImport, product) ->
            if currentImport.distributor then Schema.distributors.find {_id: currentImport.distributor}
            else Schema.partners.find {_id: currentImport.partner}
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
      children: [
        find: (returnDetail, product) -> Schema.products.find {_id: returnDetail.product}
      ,
        find: (returnDetail, product) -> Schema.productUnits.find {_id: returnDetail.unit}
      ]
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

Schema.branchProductSummaries.allow
  insert: -> true
  update: -> true
  remove: -> true


Schema.productUnits.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.branchProductUnits.allow
  insert: -> true
  update: -> true
  remove: -> true



Schema.productDetails.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.productLosts.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.expiringProducts.allow
  insert: -> true
  update: -> true
  remove: -> true