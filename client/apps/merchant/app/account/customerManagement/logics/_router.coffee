scope = logics.customerManagement
lemon.addRoute
  template: 'customerManagement'
  waitOnDependency: 'customerManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.customerManagementInit, 'customerManagement')
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.customerManagementReactive)

    return {
      listingGridOptions: scope.listingGridOptions
      managedCustomerList: scope.managedCustomerList
    }
, Apps.Merchant.RouterBase
