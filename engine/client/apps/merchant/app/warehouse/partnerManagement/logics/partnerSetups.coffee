Apps.Merchant.partnerManagementInit.push (scope) ->
  scope.createPartner = (template)->
    partner =
      parentMerchant: Session.get('myProfile').parentMerchant
      creator       : Session.get('myProfile').user
      name          : Session.get("partnerManagementSearchFilter")
    existedQuery = {name: partner.name, parentMerchant: partner.parentMerchant}
    if Schema.partners.findOne(existedQuery)
      template.ui.$searchFilter.notify("Đối tác đã tồn tại.", {position: "bottom"})
    else
      Schema.partners.insert  partner, (error, result) ->
        if error then console.log error
        else
          UserSession.set('currentPartnerManagementSelection', result)
#          Meteor.subscribe('partnerManagementData', partnerId)
          MetroSummary.updateMetroSummaryBy(['partner'])
          template.ui.$searchFilter.val(''); Session.set("partnerManagementSearchFilter", "")
