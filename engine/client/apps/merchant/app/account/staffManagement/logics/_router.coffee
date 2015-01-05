scope = logics.staffManagement
lemon.addRoute
  template: 'staffManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.staffManagementInit, 'staffManagement')
      Session.set "currentAppInfo",
        name: "nhân viên"
        navigationPartial:
          template: "staffManagementNavigationPartial"
          data: {}
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.staffManagementReactive)

    return {
      currentStaffData :
        currentStaff : Session.get("staffManagementCurrentStaff")
        genderSelectOptions: scope.genderSelectOptions
        roleSelectOptions: scope.roleSelectOptions
        branchSelectOptions: scope.branchSelectOptions
        warehouseSelectOptions: scope.warehouseSelectOptions


      managedStaffList : scope.managedStaffList
      genderSelectOptions : scope.genderSelectOptions

    }
, Apps.Merchant.RouterBase