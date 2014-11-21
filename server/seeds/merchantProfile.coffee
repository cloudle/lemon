Meteor.methods
  generateMerchantProfiles: ->
    allMerchants = Schema.merchants.find({}).fetch()
    for merchant in allMerchants
      if Schema.merchantProfiles.findOne({merchant: merchant._id})
        Schema.merchantProfiles.insert({merchant: merchant._id})