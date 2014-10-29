Schema.add 'providers', class Provider
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})
  @insideBranch: (branchId) -> @schema.find({merchant: branchId})

  @findBy: (providerId, parentMerchantId = null)->
    if !parentMerchantId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.findOne({
      _id            : providerId
      parentMerchant : parentMerchantId ? myProfile.parentMerchant
    })
