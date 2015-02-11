Meteor.publishComposite 'availablePartners', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      branchProfile = Schema.branchProfiles.findOne({merchant: profile.currentMerchant}) if profile
      return EmptyQueryResult if !branchProfile
      Schema.partners.find({parentMerchant: profile.currentMerchant})
  #    children: [
  #      find: (product) -> Schema.buildInProducts.find {_id: product.buildInProduct}
  #    ]
  }

Meteor.publishComposite 'partnerManagementData', (id) ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      branchProfile = Schema.branchProfiles.findOne({merchant: profile.currentMerchant}) if profile
      return EmptyQueryResult if !branchProfile
      Schema.partners.find({_id: id})
    children: [
      find: (partner) -> Schema.imports.find {_id: {$in: partner.importList} }
    ,
      find: (partner) -> Schema.productDetails.find {_id: {$in: partner.productDetailList} }
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
  }


Schema.partners.allow
  insert: -> true
  update: -> true
  remove: -> true