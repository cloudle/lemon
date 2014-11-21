Apps.Merchant.customerManagementReactive.push (scope) ->
  if Session.get("myProfile")
    customers = Schema.customers.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    groupedCustomers = _.groupBy customers, (customer) -> customer.name.split(' ').pop().substr(0, 1)
    console.log groupedCustomers
    scope.managedCustomerList = []
    for key, childs of groupedCustomers
      scope.managedCustomerList.push {key: key, childs: childs}