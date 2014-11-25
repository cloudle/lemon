logics.customerManagement = {}
Apps.Merchant.customerManagementInit = []
Apps.Merchant.customerManagementReactive = []

Apps.Merchant.customerManagementReactive.push (scope) ->
  if Session.get('allowCreateNewCustomer') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreate = allowCreate

  if Session.get("customerManagementCurrentCustomer")
    Meteor.subscribe('availableCustomSaleOf', Session.get("customerManagementCurrentCustomer")._id)
    Meteor.subscribe('availableSaleOf', Session.get("customerManagementCurrentCustomer")._id)