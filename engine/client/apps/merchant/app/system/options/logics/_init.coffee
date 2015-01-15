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

Apps.Merchant.merchantOptionsInit.push (scope) ->
  scope.checkUpdateAccountOption = (template) ->
    console.log template.datePicker.$dateOfBirth.datepicker().data().datepicker.dates[0]
    Session.set "merchantAccountOptionShowEditCommand",
      template.ui.$fullName.val() isnt (Session.get("myProfile").fullName ? '') or
      Session.get("merchantAccountOptionsGenderSelection") isnt (Session.get("myProfile").gender) or
      template.datePicker.$dateOfBirth.datepicker().data().datepicker.dates[0] isnt (Session.get("myProfile").dateOfBirth ? undefined) or
      template.ui.$address.val() isnt (Session.get("myProfile").address ? '') or
      template.ui.$email.val() isnt (Session.get("myProfile").email ? '') or
      template.ui.$im.val() isnt (Session.get("myProfile").im ? '')