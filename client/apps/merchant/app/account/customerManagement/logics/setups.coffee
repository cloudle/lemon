Apps.Merchant.customerManagementInit.push (scope) ->
  Session.set("customerManagementCurrentCustomer", Schema.customers.findOne())