Apps.Merchant.customerManagementReactive.push (scope) ->
  if Session.get("myProfile")
    customers = Schema.customers.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    scope.managedCustomerList = []
    if Session.get("customerManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("customerManagementSearchFilter")

      for customer in customers
        unsignedName = Helpers.RemoveVnSigns customer.name
        scope.managedCustomerList.push customer if unsignedName.indexOf(unsignedSearch) > -1

    else
      groupedCustomers = _.groupBy customers, (customer) -> customer.name.split(' ').pop().substr(0, 1).toLowerCase()
      scope.managedCustomerList.push {key: key, childs: childs} for key, childs of groupedCustomers
      scope.managedCustomerList = _.sortBy(scope.managedCustomerList, (num)-> num.key)

    if Session.get("customerManagementSearchFilter")?.trim().length > 1
      if scope.managedCustomerList.length > 0
        customerNameLists = _.pluck(scope.managedCustomerList, 'name')
        Session.set("customerManagementCreationMode", !_.contains(customerNameLists, Session.get("customerManagementSearchFilter").trim()))
      else
        Session.set("customerManagementCreationMode", true)

    else
      Session.set("customerManagementCreationMode", false)