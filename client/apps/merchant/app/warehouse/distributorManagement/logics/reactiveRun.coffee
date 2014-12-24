Apps.Merchant.distributorManagementReactive.push (scope) ->
  if Session.get("myProfile")
    distributors = Schema.distributors.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    scope.managedDistributorList = []
    if Session.get("distributorManagementSearchFilter")?.length > 0
      scope.managedDistributorList = _.filter distributors, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("distributorManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedStaffs = _.groupBy distributors, (distributor) -> distributor.name.substr(0, 1).toLowerCase() if distributor.name
      scope.managedDistributorList.push {key: key, childs: childs} for key, childs of groupedStaffs
      scope.managedDistributorList = _.sortBy(scope.managedDistributorList, (num)-> num.key)

    if Session.get("distributorManagementSearchFilter")?.trim().length > 1
      if scope.managedDistributorList.length > 0
        distributorNameLists = _.pluck(scope.managedDistributorList, 'name')
        Session.set("distributorCreationMode", !_.contains(distributorNameLists, Session.get("distributorManagementSearchFilter").trim()))
      else
        Session.set("distributorCreationMode", true)
    else
      Session.set("distributorCreationMode", false)