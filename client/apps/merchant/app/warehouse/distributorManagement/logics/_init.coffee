logics.distributorManagement = {}
Apps.Merchant.distributorManagementInit = []
Apps.Merchant.distributorManagementReactive = []

Apps.Merchant.distributorManagementReactive.push (scope) ->
  if Session.get('allowCreateDistributor') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreateDistributor = allowCreate

  if distributorId = Session.get("mySession")?.currentDistributorManagementSelection
    Session.set("distributorManagementCurrentDistributor", Schema.distributors.findOne(distributorId))

  if Session.get("distributorManagementCurrentDistributor")
    Meteor.subscribe('distributorManagementData', Session.get("distributorManagementCurrentDistributor")._id)
