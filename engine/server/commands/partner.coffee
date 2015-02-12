Meteor.methods
  addMerchantPartner: (partnerMerchantProfileId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      myMerchantProfile      = Schema.merchantProfiles.findOne({merchant: profile.parentMerchant})
      partnerMerchantProfile = Schema.merchantProfiles.findOne(partnerMerchantProfileId)
      if myMerchantProfile and partnerMerchantProfile
        submitPartner =
          parentMerchant: profile.parentMerchant
          creator       : profile.user
          buildIn       : partnerMerchantProfile.merchant
          name          : partnerMerchantProfile.companyName
          status        : 'submitPartner'
        if submitPartnerId = Schema.partners.insert submitPartner
          unSubmitPartner =
            parentMerchant: partnerMerchantProfile.merchant
            creator       : profile.user
            buildIn       : myMerchantProfile.merchant
            name          : myMerchantProfile.companyName
            partner       : submitPartnerId
            status        : 'unSubmitPartner'
          if unSubmitPartnerId = Schema.partners.insert unSubmitPartner
            Schema.partners.update submitPartnerId, $set:{partner: unSubmitPartnerId}

            Schema.merchantProfiles.update myMerchantProfile._id, $addToSet: { merchantPartnerList: partnerMerchantProfile.merchant }
            Schema.merchantProfiles.update partnerMerchantProfile._id, $addToSet: { merchantPartnerList: profile.parentMerchant }

  updateMerchantPartner: (partnerId, status = 'submit')->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      partner = Schema.partners.findOne({_id: partnerId, parentMerchant: profile.parentMerchant})
      switch status
        when 'submit'
          if partner.status is 'unSubmitPartner'
            Schema.partners.update partner._id, $set:{status: 'successPartner'}
            Schema.partners.update partner.partner, $set:{status: 'successPartner'}

        when 'delete'
          if partner.status isnt 'myMerchant' and partner.status isnt 'successPartner'
            Schema.partners.remove partner._id
            Schema.partners.remove partner.partner
            Schema.merchantProfiles.update {merchant: partner.parentMerchant}, $pull: { merchantPartnerList: partner.buildIn }
            Schema.merchantProfiles.update {merchant: partner.buildIn}, $pull: { merchantPartnerList: partner.parentMerchant }





