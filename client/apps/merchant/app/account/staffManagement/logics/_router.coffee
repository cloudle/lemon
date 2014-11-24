scope = logics.staffManagement
lemon.addRoute
  template: 'staffManagement'
  waitOnDependency: 'staffManagement'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.staffManagementInit, 'staffManagement')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.staffManagementReactive)

    return {
      managedStaffList : scope.managedStaffList
      allowCreateStaff : scope.allowCreateStaff
    }
, Apps.Merchant.RouterBase
