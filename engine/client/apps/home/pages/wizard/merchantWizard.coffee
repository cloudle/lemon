currentIndex = 0
colors = [
  '#4b97d2', # dark blue
  '#92cc8f', # light green
  '#41bb98', # mint green
  '#c9de83', # yellowish green
  '#dee569', # yellowisher green
  '#c891c0', # light purple
  '#9464a8', # med purple
  '#7755a1', # dark purple
  '#f069a1', # light pink
  '#f05884', # med pink
  '#e7457b', # dark pink
  '#ffd47e', # peach
  '#f69078'  # salmon
]

registerErrors = [
  incorrectPassword  = { reason: "Incorrect password",  message: "tài khoản tồn tại"}
]

animateBackgroundColor = ->
  $(".merchant-wizard-wrapper").css("background-color", colors[currentIndex])
  currentIndex++
  currentIndex = 0 if currentIndex > colors.length

#packageOption = (option)->
#  packageClass          : option.packageClass
#  price                 : option.price
#  duration              : option.duration
#  defaultAccountLimit   : option.accountLim
#  defaultBranchLimit    : option.branchLim
#  defaultWarehouseLimit : option.warehouseLim
#  extendAccountPrice    : option.extendAccountPrice
#  extendBranchPrice     : option.extendBranchPrice
#  extendWarehousePrice  : option.extendBranchPrice
#
#runInitMerchantWizardTracker = (context) ->
#  return if Sky.global.merchantWizardTracker
#  Sky.global.merchantWizardTracker = Tracker.autorun ->
#    Router.go('/') if Meteor.userId() is null
#    unless Session.get('merchantPackages')?.user is Meteor.userId() then Router.go('/dashboard')
#    if Session.get('merchantPackages')?.merchantRegistered then Router.go('/dashboard')
#
#    if Session.get("merchantPackages")
#      Session.set 'extendAccountLimit',   Session.get("merchantPackages").extendAccountLimit ? 0
#      Session.set 'extendBranchLimit',    Session.get("merchantPackages").extendBranchLimit ? 0
#      Session.set 'extendWarehouseLimit', Session.get("merchantPackages").extendWarehouseLimit ? 0
#
#      if Template.merchantWizard.trialPackageOption.packageClass is Session.get("merchantPackages").packageClass
#        Session.set('merchantPackage', Template.merchantWizard.trialPackageOption)
#
#      if Template.merchantWizard.oneYearsPackageOption.packageClass is Session.get("merchantPackages").packageClass
#        Session.set('merchantPackage', Template.merchantWizard.oneYearsPackageOption)
#
#      if Template.merchantWizard.threeYearsPackageOption.packageClass is Session.get("merchantPackages").packageClass
#        Session.set('merchantPackage', Template.merchantWizard.threeYearsPackageOption)
#
#      if Template.merchantWizard.fiveYearsPackageOption.packageClass is Session.get("merchantPackages").packageClass
#        Session.set('merchantPackage', Template.merchantWizard.fiveYearsPackageOption)
#
#      if Session.get("merchantPackages").companyName?.length > 0 then Session.set('companyNameValid', 'valid')
#      else Session.set('companyNameValid', 'invalid')
#
#      if Session.get("merchantPackages").companyPhone?.length > 0 then Session.set('companyPhoneValid', 'valid')
#      else Session.set('companyPhoneValid', 'invalid')
#
#      if Session.get("merchantPackages").merchantName?.length > 0 then Session.set('merchantNameValid', 'valid')
#      else Session.set('merchantNameValid', 'invalid')
#
#      if Session.get("merchantPackages").warehouseName?.length > 0 then Session.set('warehouseNameValid', 'valid')
#      else Session.set('warehouseNameValid', 'invalid')

finalAccountExtendPrice = ->
  currentPackage = Session.get('currentMerchantPackage')
  Session.get('wizardAccountPlus') * currentPackage.extendAccountPrice * currentPackage.years
finalBranchExtendPrice = ->
  currentPackage = Session.get('currentMerchantPackage')
  Session.get('wizardBranchPlus') * currentPackage.extendBranchPrice * currentPackage.years
finalWarehouseExtendPrice = ->
  currentPackage = Session.get('currentMerchantPackage')
  Session.get('wizardWarehousePlus') * currentPackage.extendWarehousePrice * currentPackage.years


lemon.defineWidget Template.merchantWizard,
  accountExtendPrice: -> Session.get('currentMerchantPackage')?.extendAccountPrice
  branchExtendPrice: -> Session.get('currentMerchantPackage')?.extendBranchPrice
  warehouseExtendPrice: -> Session.get('currentMerchantPackage')?.extendWarehousePrice
  packageYears: -> Session.get('currentMerchantPackage')?.years
  packagePrice: -> Session.get('currentMerchantPackage')?.price

  finalAccountExtendPrice: -> finalAccountExtendPrice()
  finalBranchExtendPrice: -> finalBranchExtendPrice()
  finalWarehouseExtendPrice: -> finalWarehouseExtendPrice()
  crossFinalExtendPrice: -> finalAccountExtendPrice() + finalBranchExtendPrice() + finalWarehouseExtendPrice()
  crossFinalPrice: -> Session.get('currentMerchantPackage').price + finalAccountExtendPrice() + finalBranchExtendPrice() + finalWarehouseExtendPrice()

  updateValid: ->
    if !merchantProfile = logics.merchantWizard.merchantProfile then return 'disabled'
    if !merchantProfile.companyName    || merchantProfile.companyName.length is 0 then return 'disabled'
    if !merchantProfile.contactPhone   || merchantProfile.contactPhone.length is 0 then return 'disabled'
    if !merchantProfile.contactAddress || merchantProfile.contactAddress.length is 0 then return 'disabled'
    if !merchantProfile.merchantName   || merchantProfile.merchantName.length is 0 then return 'disabled'
#    if !merchantProfile.warehouseName || merchantProfile.warehouseName.length is 0 then return 'disabled'

  rendered: ->
    self = @
    Meteor.setTimeout ->
      animateBackgroundColor()
      self.bgInterval = Meteor.setInterval(animateBackgroundColor, 15000)
    , 5000
  destroyed: -> Meteor.clearInterval(@bgInterval)
  events:
    "blur #companyName"  : (event, template) ->
      $companyName = $(template.find("#companyName"))
      if $companyName.val().length > 0
        Schema.merchantProfiles.update logics.merchantWizard.merchantProfile._id, $set: {companyName: $companyName.val()}
      else
        $companyName.notify('tên công ty không được để trống', {position: "bottom"})

    "blur #companyPhone" : (event, template) ->
      $companyPhone = $(template.find("#companyPhone"))
      if $companyPhone.val().length > 0
        Schema.merchantProfiles.update logics.merchantWizard.merchantProfile._id, $set: {contactPhone: $companyPhone.val()}
      else
        $companyPhone.notify('số điện thoại không được để trống!', {position: "bottom"})

    "blur #contactAddress" : (event, template) ->
      $contactAddress = $(template.find("#contactAddress"))
      if $contactAddress.val().length > 0
        Schema.merchantProfiles.update logics.merchantWizard.merchantProfile._id, $set: {contactAddress: $contactAddress.val()}
      else
        $contactAddress.notify('địa chỉ chi nhánh không được để trống!', {position: "bottom"})

    "blur #merchantName" : (event, template) ->
      $merchantName = $(template.find("#merchantName"))
      if $merchantName.val().length > 0
        Schema.merchantProfiles.update logics.merchantWizard.merchantProfile._id, $set: {merchantName: $merchantName.val()}
      else
        $merchantName.notify('tên chi nhánh không được để trống!', {position: "bottom"})

    "blur #warehouseName": (event, template) ->
      $warehouseName = $(template.find("#warehouseName"))
      if $warehouseName.val().length > 0
        Schema.merchantProfiles.update logics.merchantWizard.merchantProfile._id, $set: {warehouseName: $warehouseName.val()}
      else
        $warehouseName.notify('tên kho hàng không để trống!', {position: "bottom"})

    "click .package-block": (event, template) -> Session.set('currentMerchantPackage', @options)
    "click .finish-register": (event, template) ->
      console.log template.data.merchantProfile
      Schema.merchantProfiles.update(template.data.merchantProfile._id, {$set: {merchantRegistered: true}})
      Schema.merchants.update(Session.get('myProfile').currentMerchant, {$set: {name: template.data.merchantProfile.merchantName}})
      Schema.warehouses.update(Session.get('myProfile').currentWarehouse, {$set: {name: template.data.merchantProfile.warehouseName}})
      Schema.userProfiles.update(Session.get('myProfile')._id, {$set: {roles: ["admin"]}})
      Router.go('/merchant')
    "click .register-logout.btn": -> lemon.logout()

#  merchantPackage: -> Session.get('merchantPackages')
#  updateValid: ->
#    if Session.get('companyNameValid') is 'invalid' then return 'invalid'
#    if Session.get('companyPhoneValid') is 'invalid' then return 'invalid'
#    if Session.get('merchantNameValid') is 'invalid' then return 'invalid'
#    if Session.get('warehouseNameValid') is 'invalid' then return 'invalid'
#    return 'valid'
#
#  created: ->
#    Router.go('/') if Meteor.userId() is null
#    if Session.get("currentProfile")
#      Router.go('/dashboard') if Session.get("currentProfile").merchantRegistered
#
#    Session.setDefault('companyNameValid', 'invalid')
#    Session.setDefault('companyPhoneValid', 'invalid')
#    Session.setDefault('merchantNameValid', 'invalid')
#    Session.setDefault('warehouseNameValid', 'invalid')
#
#    Session.setDefault('extendAccountLimit', 0)
#    Session.setDefault('extendBranchLimit', 0)
#    Session.setDefault('extendWarehouseLimit', 0)
#
#  rendered: -> runInitMerchantWizardTracker()
#
#  events:
#    "click .package-block.free": (event, template)->
#      Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: packageOption(Template.merchantWizard.trialPackageOption)
#
#    "click .package-block.basic": (event, template)->
#      Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: packageOption(Template.merchantWizard.oneYearsPackageOption)
#
#    "click .package-block.premium": (event, template)->
#      Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: packageOption(Template.merchantWizard.threeYearsPackageOption)
#
#    "click .package-block.advance": (event, template)->
#      Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: packageOption(Template.merchantWizard.fiveYearsPackageOption)
#
#    "click #merchantUpdate.valid": (event, template)->
#      UserProfile.findOne(Session.get('currentProfile')?._id).updateNewMerchant()
#      Router.go('/dashboard')
#
#
#
#
#
#
