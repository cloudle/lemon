Meteor.publishComposite 'availablePartners', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      branchProfile = Schema.branchProfiles.findOne({merchant: profile.currentMerchant}) if profile
      return EmptyQueryResult if !branchProfile
      Schema.partners.find({parentMerchant: profile.currentMerchant})
  }

Meteor.publishComposite 'availableMerchantPartners', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !profile
      merchantList = []
      Schema.merchants.find({merchantType: "merchant", parent:{$exists: false}}).forEach((merchant)-> merchantList.push merchant._id)
      Schema.merchantProfiles.find { merchant: {$in:merchantList}, packageClassActive: true }
  }

Meteor.publishComposite 'partnerManagementData', (id) ->
  self = @
  profile = Schema.userProfiles.findOne({user: self.userId})
  return {
    find: ->
      branchProfile = Schema.branchProfiles.findOne({merchant: profile.currentMerchant}) if profile
      return EmptyQueryResult if !branchProfile
      Schema.partners.find({_id: id})
    children: [
      find: (partner) -> Schema.imports.find {partner: partner._id}
      children: [
        find: (currentImport, partner) -> Schema.productDetails.find {import: currentImport._id}
        children: [
          find: (productDetail, partner) -> Schema.branchProductSummaries.find { _id: productDetail.branchProduct }
        ,
          find: (productDetail, partner) ->
            if productDetail.unit then Schema.branchProductUnits.find { _id: productDetail.branchUnit } else EmptyQueryResult
        ,
          find: (productDetail, partner) -> Schema.products.find { _id: productDetail.product }
          children: [
            find: (product, partner) -> Schema.buildInProducts.find { _id: product.buildInProduct }
          ]
        ,
          find: (productDetail, partner) ->
            if productDetail.unit then Schema.productUnits.find { _id: productDetail.unit } else EmptyQueryResult
          children: [
            find: (productUnit, partner) -> Schema.buildInProductUnits.find { _id: productUnit.buildInProductUnit }
          ]
        ]
      ]
    ,
      find: (partner) -> Schema.partnerSales.find {partner: partner._id}
      children: [
        find: (partnerSale, partner) -> Schema.partnerSaleDetails.find {partnerSales: partnerSale._id}
        children: [
          find: (partnerSaleDetail, partner) -> Schema.buildInProducts.find {_id: partnerSaleDetail.buildInProduct}
          children: [
            find: (buildInProduct, partner) -> Schema.products.find {buildInProduct: buildInProduct._id, merchant: profile.currentMerchant}
          ]
        ,
          find: (partnerSaleDetail, partner) ->
            if partnerSaleDetail.buildInProductUnit
              Schema.buildInProductUnits.find {_id: partnerSaleDetail.buildInProductUnit}
            else EmptyQueryResult
          children: [
            find: (buildInProductUnit, partner) -> Schema.productUnits.find {buildInProductUnit: buildInProductUnit._id, merchant: profile.currentMerchant}
          ]
        ]
      ]
    ]
  }


Schema.partners.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.partnerSales.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.partnerSaleDetails.allow
  insert: -> true
  update: -> true
  remove: -> true