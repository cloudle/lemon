logics.providerManagement = {}
Apps.Merchant.providerManagementInit = []
Apps.Merchant.providerManagementReactive = []

Apps.Merchant.providerManagementReactive.push (scope) ->
  if Session.get('allowCreateProvider') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreateProvider = allowCreate

  if Session.get("providerManagementCurrentProvider")
    Meteor.subscribe('allProductDetailBy', Session.get("providerManagementCurrentProvider")._id)
    Meteor.subscribe('allImportDetailBy', Session.get("providerManagementCurrentProvider")._id)