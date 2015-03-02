scope = logics.partnerManagement
lemon.addRoute
  template: 'partnerManagement'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.partnerManagementInit, 'partnerManagement')
      Session.set "currentAppInfo",
        name: "đối tác"
        navigationPartial:
          template: "partnerManagementNavigationPartial"
          data: {}
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.partnerManagementReactive)
    return {
      managedMyPartnerList       : scope.managedMyPartnerList
      managedUnSubmitPartnerList : scope.managedUnSubmitPartnerList
      managedMerchantPartnerList : scope.managedMerchantPartnerList
      managedUnDeletePartnerList : scope.managedUnDeletePartnerList
    }
, Apps.Merchant.RouterBase
