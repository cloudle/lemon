#Apps.Merchant.distributorManagementReactive.push (scope) ->
#  if Session.get("myProfile")
#    distributors = Schema.distributors.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
#    scope.managedDistributorList = []
#    if Session.get("distributorManagementSearchFilter")?.length > 0
#      scope.managedDistributorList = _.filter distributors, (item) ->
#        unsignedTerm = Helpers.RemoveVnSigns Session.get("distributorManagementSearchFilter")
#        unsignedName = Helpers.RemoveVnSigns item.name
#        unsignedName.indexOf(unsignedTerm) > -1
#    else
#      groupedStaffs = _.groupBy distributors, (distributor) -> distributor.name.split(' ').pop().substr(0, 1) if distributor.name
#      scope.managedDistributorList.push {key: key, childs: childs} for key, childs of groupedStaffs
#      scope.managedDistributorList = _.sortBy(scope.managedDistributorList, (num)-> num.key)