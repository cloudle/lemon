Apps.Merchant.customerManagementReactive.push (scope) ->
  if Session.get("myProfile")
    customers = Schema.customers.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    scope.managedCustomerList = []
    if Session.get("customerManagementSearchFilter")?.length > 0
      scope.managedCustomerList = _.filter customers, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("customerManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedCustomers = _.groupBy customers, (customer) -> customer.name.split(' ').pop().substr(0, 1)
      console.log groupedCustomers
      scope.managedCustomerList.push {key: key, childs: childs} for key, childs of groupedCustomers
      scope.managedCustomerList = _.sortBy(scope.managedCustomerList, (num)-> num.key)