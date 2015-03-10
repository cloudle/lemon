Apps.Merchant.partnerManagementInit.push (scope) ->
  scope.createPartner = (template)->
    if profile = Session.get('myProfile')
      myMerchantProfile = Schema.merchantProfiles.findOne({merchant: profile.parentMerchant})
      partner =
        parentMerchant: profile.parentMerchant
        creator       : profile.user
        name          : Session.get("partnerManagementSearchFilter")
      existedQuery = {name: partner.name, parentMerchant: partner.parentMerchant}
      if Schema.partners.findOne(existedQuery)
        template.ui.$searchFilter.notify("Đối tác đã tồn tại.", {position: "bottom"})
      else
        Schema.partners.insert partner, (error, result) ->
          if error then console.log error
          else
            Schema.merchantProfiles.update myMerchantProfile._id, $addToSet: { partnerList: result }
            UserSession.set('currentPartnerManagementSelection', result)
            template.ui.$searchFilter.val(''); Session.set("partnerManagementSearchFilter", "")
