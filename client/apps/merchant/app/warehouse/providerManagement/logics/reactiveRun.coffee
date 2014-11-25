Apps.Merchant.providerManagementReactive.push (scope) ->
  if Session.get("myProfile")
    providers = Schema.providers.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    scope.managedProviderList = []
    if Session.get("providerManagementSearchFilter")?.length > 0
      scope.managedProviderList = _.filter providers, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("providerManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedStaffs = _.groupBy providers, (provider) -> provider.name.split(' ').pop().substr(0, 1) if provider.name
      console.log groupedStaffs
      scope.managedProviderList.push {key: key, childs: childs} for key, childs of groupedStaffs
      scope.managedProviderList = _.sortBy(scope.managedProviderList, (num)-> num.key)
