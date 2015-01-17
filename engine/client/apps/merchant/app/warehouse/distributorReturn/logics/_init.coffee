logics.distributorReturn = {}
Apps.Merchant.distributorReturnInit = []
Apps.Merchant.distributorReturnReactiveRun = []

Apps.Merchant.distributorReturnInit.push (scope) ->
Apps.Merchant.distributorReturnReactiveRun.push (scope) ->
  Session.set('currentDistributorReturn', Schema.returns.findOne(returnId)) if returnId = Session.get('mySession')?.currentDistributorReturn

  if Session.get('currentDistributorReturn')
    Session.set('distributorReturnCurrentDistributor', Schema.distributors.findOne(Session.get('currentDistributorReturn')?.distributor))

  if Session.get("distributorReturnEditingRowId")
    Session.set("distributorReturnEditingRow", Schema.returnDetails.findOne(Session.get("distributorReturnEditingRowId")))