toggleCollapse = -> Session.set 'collapse', if Session.get('collapse') is 'collapsed' then '' else 'collapsed'
arrangeSideBar = (context) ->
  messengerHeight = $("#messenger").outerHeight()
  brandingHeight = $(".branding").outerHeight()
  msgListHeight = $(window).height() - brandingHeight - messengerHeight
  $("ul.messenger-list").css("height", "#{msgListHeight}px") if msgListHeight > 150

startHomeTracker = ->
  Apps.Merchant.homeTracker = Tracker.autorun ->
    if Session.get("myProfile")
      purchase = Schema.merchantPurchases.findOne({merchant: Session.get("myProfile").currentMerchant})
      return if !purchase

      if !purchase.merchantRegistered
        if purchase.user is Meteor.userId()
          Router.go('/merchantWizard')
        else
          Router.go('/')

      Session.set('metroSummary', Schema.metroSummaries.findOne({merchant: Session.get("myProfile").currentMerchant}))
      if Session.get('metroSummary')?.notifyExpire
        console.log 'het han'

destroyHomeTracker = -> Apps.Merchant.homeTracker.stop()

lemon.defineWidget Template.merchantLayout,
  collapse: -> Session.get('collapse') ? ''

  created: -> startHomeTracker()

  rendered: ->
    arrangeSideBar(@)

    $(window).resize ->
      Helpers.arrangeAppLayout()
      arrangeSideBar(@)

    Helpers.animateUsing("#container", "bounceInDown")

  destroyed: ->
    $(window).off("resize")
    destroyHomeTracker()
  events:
    "click .collapse-toggle": -> toggleCollapse(); Helpers.arrangeAppLayout()