logics.customerReturn = {}
Apps.Merchant.customerReturnInit = []
Apps.Merchant.customerReturnReactiveRun = []

Apps.Merchant.customerReturnInit.push (scope) ->
Apps.Merchant.customerReturnReactiveRun.push (scope) ->
  Session.set('currentCustomerReturn', Schema.returns.findOne(returnId)) if returnId = Session.get('mySession')?.currentCustomerReturn

  if Session.get('currentCustomerReturn')
    Session.set('customerReturnCurrentCustomer', Schema.customers.findOne(Session.get('currentCustomerReturn')?.customer))

  if Session.get("customerReturnEditingRowId")
    Session.set("customerReturnEditingRow", Schema.returnDetails.findOne(Session.get("customerReturnEditingRowId")))