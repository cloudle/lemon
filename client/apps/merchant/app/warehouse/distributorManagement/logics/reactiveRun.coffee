Apps.Merchant.distributorManagementReactive.push (scope) ->
  if Session.get("myProfile")
    distributors = Schema.distributors.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    groupedDistributors = _.groupBy distributors, (distributor) -> distributor.name.split(' ').pop().substr(0, 1)
    console.log groupedDistributors
    scope.managedDistributorList = []
    for key, childs of groupedDistributors
      scope.managedDistributorList.push {key: key, childs: childs}