scope = logics.customerManagement
lemon.addRoute
  template: 'customerManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.customerManagementInit, 'customerManagement')
      Session.set "currentAppInfo",
        name: "khách hàng"
        navigationPartial:
          template: "customerManagementNavigationPartial"
          data: {}
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.customerManagementReactive)

    return {
      managedCustomerList : scope.managedCustomerList
      genderSelectOptions : scope.genderSelectOptions
#      allowCreate         : scope.allowCreate
    }
, Apps.Merchant.RouterBase