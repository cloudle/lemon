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
      Session.set "merchantOptionsCurrentDynamics", scope.settings.common[0]

Apps.Merchant.merchantOptionsInit.push (scope) ->
  scope.checkUpdateAccountOption = (template) ->
    if Session.get("myProfile")
      Session.set "merchantAccountOptionShowEditCommand",
        template.ui.$fullName.val() isnt (Session.get("myProfile").fullName ? '') or
        Session.get("merchantAccountOptionsGenderSelection") isnt (Session.get("myProfile").gender) or
        template.datePicker.$dateOfBirth.datepicker().data().datepicker.dates[0]?.toDateString() isnt (Session.get("myProfile").dateOfBirth?.toDateString() ? undefined) or
        template.ui.$address.val() isnt (Session.get("myProfile").address ? '') or
        template.ui.$emailAccount.val() isnt (Session.get("myProfile").email ? '') or
        template.ui.$im.val() isnt (Session.get("myProfile").im ? '')

  scope.updateAccountOption = (template)->
    if Session.get "merchantAccountOptionShowEditCommand"
      profile     = Session.get("myProfile")
      fullName    = template.ui.$fullName.val()
      gender      = Session.get("merchantAccountOptionsGenderSelection")
      dateOfBirth = template.datePicker.$dateOfBirth.datepicker().data().datepicker.dates[0]
      address     = template.ui.$address.val()
      email       = template.ui.$emailAccount.val()
      im          = template.ui.$im.val()

      accountProfileOption ={}
      accountProfileOption.fullName    = fullName if fullName isnt (profile.fullName ? '')
      accountProfileOption.gender      = gender if gender isnt profile.gender
      accountProfileOption.dateOfBirth = dateOfBirth if dateOfBirth?.toDateString() isnt (profile.dateOfBirth?.toDateString() ? undefined)
      accountProfileOption.address     = address if address isnt (profile.address ? '')
      accountProfileOption.email       = email if email isnt (profile.email ? '')
      accountProfileOption.im          = im if im isnt (profile.im ? '')

      Schema.userProfiles.update profile._id, $set: accountProfileOption
      Session.set "merchantAccountOptionShowEditCommand"

  scope.checkAccountChangePassword = (template) ->
    if Session.get("myProfile")
      oldPassword     = template.ui.$oldPassword.val()
      newPassword     = template.ui.$newPassword.val()
      confirmPassword = template.ui.$confirmPassword.val()

      if oldPassword.length > 0 and newPassword.length > 0 and  newPassword is confirmPassword
        Session.set "merchantAccountOptionChangePasswordCommand", true
      else
        Session.set "merchantAccountOptionChangePasswordCommand"


  scope.updateAccountOptionChangePassword = (template)->
    if Session.get("merchantAccountOptionChangePasswordCommand")
      oldPassword     = template.ui.$oldPassword
      newPassword     = template.ui.$newPassword
      confirmPassword = template.ui.$confirmPassword

      if oldPassword.val().length > 0 and newPassword.val().length > 0 and  newPassword.val() is confirmPassword.val()
        Accounts.changePassword oldPassword.val(), newPassword.val(), (error) ->
          if error
             console.log error
          else
            oldPassword.val('')
            newPassword.val('')
            confirmPassword.val('')

            Session.set "merchantAccountOptionChangePasswordCommand"
            console.log 'Thay đổi mật khẩu thành công.'






