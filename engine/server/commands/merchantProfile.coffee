Meteor.methods
  generateMerchantProfiles: ->
    allMerchants = Schema.merchants.find({}).fetch()
    for merchant in allMerchants
      if !Schema.branchProfiles.findOne({merchant: merchant._id})
        Schema.branchProfiles.insert({merchant: merchant._id})

  reUpdateGeraProduct: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      geraProduct = []; option = { parentMerchant: profile.parentMerchant, buildInProduct: {$exists: true} }
      Schema.products.find(option).forEach( (product) -> geraProduct.push product.buildInProduct )
      Schema.merchantProfiles.update {merchant: profile.parentMerchant}, $set:{geraProduct: geraProduct}
