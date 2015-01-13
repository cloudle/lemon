toggleCollapse = -> Session.set 'collapse', if Session.get('collapse') is 'collapsed' then '' else 'collapsed'
arrangeSideBar = (context) ->
  messengerHeight = $("#messenger").outerHeight()
  brandingHeight = $(".branding").outerHeight()
  msgListHeight = $(window).height() - brandingHeight - messengerHeight
  $("ul.messenger-list").css("height", "#{msgListHeight}px") if msgListHeight > 150

startHomeTracker = ->
  Apps.Merchant.homeTracker = Tracker.autorun ->
    if Session.get("myProfile")
      merchantProfile = Schema.merchantProfiles.findOne({merchant: Session.get("myProfile").currentMerchant})
      return if !merchantProfile
      if !merchantProfile.merchantRegistered
        if merchantProfile.user is Meteor.userId()
          Router.go('/merchantWizard')
        else
          Router.go('/')

destroyHomeTracker = -> Apps.Merchant.homeTracker.stop()

lemon.defineWidget Template.merchantLayout,
  collapse: -> Session.get('collapse') ? ''

  created: ->
    Session.set("collapse", 'collapsed')
    startHomeTracker()

  rendered: ->
    arrangeSideBar(@)

    $(window).resize ->
      Helpers.arrangeAppLayout()
      arrangeSideBar(@)
      $(".nano").nanoScroller()

  destroyed: ->
    $(window).off("resize")
    destroyHomeTracker()
  events:
    "click .collapse-toggle": -> toggleCollapse(); Helpers.arrangeAppLayout()