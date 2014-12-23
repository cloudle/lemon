logics.returnManagement = {}
Apps.Merchant.returnManagementInit = []
Apps.Merchant.returnManagementReactiveRun = []

Apps.Merchant.returnManagementInit.push (scope) ->
Apps.Merchant.returnManagementReactiveRun.push (scope) ->
  Session.set('currentReturn', Schema.returns.findOne(returnId)) if returnId = Session.get('mySession')?.currentReturn

  if Session.get('currentReturn')
    Session.set('returnManagementCurrentCustomer', Schema.customers.findOne(Session.get('currentReturn')?.customer))

  if Session.get("returnEditingRowId")
    Session.set("returnEditingRow", Schema.returnDetails.findOne(Session.get("returnEditingRowId")))