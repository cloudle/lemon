scope = logics.customerManagement
lemon.addRoute
  template: 'customerManagement'
  waitOnDependency: 'customerManagement'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.customerManagementInit, 'customerManagement')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.customerManagementReactive)

    return {
      managedCustomerList : scope.managedCustomerList
      genderSelectOptions : scope.genderSelectOptions
      allowCreate         : scope.allowCreate
    }
, Apps.Merchant.RouterBase
