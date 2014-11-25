logics.distributorManagement = {}
Apps.Merchant.distributorManagementInit = []
Apps.Merchant.distributorManagementReactive = []

Apps.Merchant.distributorManagementReactive.push (scope) ->
  if Session.get('allowCreateDistributor') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreateDistributor = allowCreate

  if Session.get("distributorManagementCurrentDistributor")
    Meteor.subscribe('oldPayable', Session.get("distributorManagementCurrentDistributor")._id)
