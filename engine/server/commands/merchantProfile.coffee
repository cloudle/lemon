Meteor.methods
  generateMerchantProfiles: ->
    allMerchants = Schema.merchants.find({}).fetch()
    for merchant in allMerchants
      if !Schema.branchProfiles.findOne({merchant: merchant._id})
        Schema.branchProfiles.insert({merchant: merchant._id})