Apps.Home.merchantWizardReactive.push (scope) ->
  scope.purchase = Schema.merchantPurchases.findOne({merchant: Session.get('myProfile')?.currentMerchant})