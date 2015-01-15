logics.merchantOptions = {}
Apps.Merchant.merchantOptionsInit = []
Apps.Merchant.merchantOptionsReactive = []

scope = logics.merchantOptions

lemon.addRoute
  template: 'merchantOptions'
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.merchantOptionsInit, 'customerManagement')
      Session.set "currentAppInfo",
        name: "hệ thống"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.merchantOptionsReactive)

    return {
      settings: scope.settings
      merchantProfile: scope.myMerchantProfile
      myProfile: scope.myProfile
    }
, Apps.Merchant.RouterBase

Apps.Merchant.merchantOptionsReactive.push (scope) ->
  if Session.get("myProfile")
    scope.myProfile = Session.get("myProfile")
    scope.myMerchantProfile = Schema.merchantProfiles.findOne {merchant: Session.get("myProfile").parentMerchant}
    if !Session.get("merchantOptionsCurrentDynamics") and scope.settings?.common
      Session.set "merchantOptionsCurrentDynamics", scope.settings.common[1]