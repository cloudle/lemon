scope = logics.staffManagement
lemon.addRoute
  template: 'staffManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.staffManagementInit, 'staffManagement')
      Session.set "currentAppInfo",
        name: "khách hàng"
        navigationPartial:
          template: "staffManagementNavigationPartial"
          data: {}
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.staffManagementReactive)

    return {
      managedStaffList : scope.managedStaffList
      genderSelectOptions : scope.genderSelectOptions
#      allowCreate         : scope.allowCreate
    }
, Apps.Merchant.RouterBase