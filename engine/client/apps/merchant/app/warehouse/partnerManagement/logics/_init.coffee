logics.partnerManagement = {}
Apps.Merchant.partnerManagementInit = []
Apps.Merchant.partnerManagementReactive = []

Apps.Merchant.partnerManagementReactive.push (scope) ->
  if partnerId  = Session.get("mySession")?.currentPartnerManagementSelection
    Session.set("partnerManagementCurrentPartner", Schema.partners.findOne(partnerId))