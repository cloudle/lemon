logics.merchantHome = {}
Apps.Merchant.homeInit = []
Apps.Merchant.homeReactive = []

Apps.Merchant.homeReactive.push (scope) ->
  if profile = Session.get('myProfile')
    scope.summary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant})
    scope.merchant = Schema.merchantProfiles.findOne({merchant: profile.parentMerchant})
