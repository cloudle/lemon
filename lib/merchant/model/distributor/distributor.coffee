Schema.add 'distributors', "Distributor", class Distributor
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})
  @canDeleteByMe: () ->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      @schema.find
        parentMerchant: userProfile.parentMerchant
        creator       : userProfile.user
        allowDelete   : true