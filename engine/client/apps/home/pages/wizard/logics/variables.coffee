Apps.Home.merchantWizardReactive.push (scope) ->
  scope.merchantProfile = Schema.merchantProfiles.findOne({merchant: Session.get('myProfile')?.currentMerchant})