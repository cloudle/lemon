Apps.Merchant.returnManagementInit.push (scope) ->
  scope.currentReturnHistory = Schema.returns.find().fetch()
