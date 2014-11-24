logics.customerManagement = {}
Apps.Merchant.customerManagementInit = []
Apps.Merchant.customerManagementReactive = []

Apps.Merchant.customerManagementReactive.push (scope) ->
  if Session.get('allowCreateNewCustomer') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreate = allowCreate

  if Session.get("customerManagementCurrentCustomer")
    Meteor.subscribe('oldReceivable', Session.get("customerManagementCurrentCustomer")._id)