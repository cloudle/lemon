Apps.Merchant.providerManagementReactive.push (scope) ->
  if Session.get("myProfile")
    providers = Schema.providers.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    groupedProviders = _.groupBy providers, (provider) -> provider.name.split(' ').pop().substr(0, 1)
    console.log groupedProviders
    scope.managedProviderList = []
    for key, childs of groupedProviders
      scope.managedProviderList.push {key: key, childs: childs}