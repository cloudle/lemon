Apps.Merchant.partnerManagementReactive.push (scope) ->
  if profile = Session.get("myProfile")
    scope.managedMyPartnerList = []; scope.managedMerchantPartnerList = []; scope.merchantPartnerList = []
    scope.myPartnerList = Schema.partners.find({parentMerchant: profile.parentMerchant})

    if Session.get("partnerManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("partnerManagementSearchFilter")
      scope.myPartnerList.forEach(
        (myPartner)->
          unsignedName = Helpers.RemoveVnSigns myPartner.name
          scope.managedMyPartnerList.push myPartner if unsignedName.indexOf(unsignedSearch) > -1
      )
#      for merchantPartner in scope.merchantPartnerList
#        unsignedName = Helpers.RemoveVnSigns merchantPartner.name
#        scope.managedMerchantPartnerList.push merchantPartner if unsignedName.indexOf(unsignedSearch) > -1
    else
      groupedPartners = _.groupBy scope.myPartnerList.fetch(), (partner) -> partner.name.substr(0, 1).toLowerCase() if partner.name
      scope.managedMyPartnerList.push {key: key, childs: childs} for key, childs of groupedPartners
      scope.managedMyPartnerList = _.sortBy(scope.managedMyPartnerList, (num)-> num.key)

    if Session.get("partnerManagementSearchFilter")?.trim().length > 1
      if scope.managedMyPartnerList.length + scope.managedMerchantPartnerList > 0
        partnerNameLists = _.pluck(scope.managedMyPartnerList, 'name')
        Session.set("partnerManagementCreationMode", !_.contains(partnerNameLists, Session.get("partnerManagementSearchFilter").trim()))
      else
        Session.set("partnerManagementCreationMode", true)
    else
      Session.set("partnerManagementCreationMode", false)