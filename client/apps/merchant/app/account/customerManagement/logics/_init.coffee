logics.customerManagement = {}
Apps.Merchant.customerManagementInit = []
Apps.Merchant.customerManagementReactive = []

Apps.Merchant.customerManagementReactive.push (scope) ->
  if Session.get('allowCreateNewCustomer') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreate = allowCreate

  if customerId = Session.get("mySession")?.currentCustomerManagementSelection
    Session.set("customerManagementCurrentCustomer", Schema.customers.findOne(customerId))

  if Session.get("customerManagementCurrentCustomer")
    #customerManagementData
    Meteor.subscribe('customerManagementData', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableCustomSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableReturnOf', Session.get("customerManagementCurrentCustomer")._id)