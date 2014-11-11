toggleCollapse = -> Session.set 'collapse', if Session.get('collapse') is 'collapsed' then '' else 'collapsed'

startHomeTracker = ->
  Apps.Merchant.homeTracker = Tracker.autorun ->
    purchase = Schema.merchantPurchases.findOne({merchant: Session.get("myProfile")?.currentMerchant})
    console.log purchase
    return if !purchase
    if !purchase.merchantRegistered
      if purchase.user is Meteor.userId()
        Router.go('/merchantWizard')
      else
        Router.go('/')

destroyHomeTracker = -> Apps.Merchant.homeTracker.stop()

lemon.defineWidget Template.merchantLayout,
  collapse: -> Session.get('collapse') ? ''

  created: -> startHomeTracker()

  rendered: ->
    $(window).resize -> Helpers.arrangeAppLayout()
    Helpers.animateUsing("#container", "bounceInDown")

  destroyed: ->
    $(window).off("resize")
    destroyHomeTracker()
  events:
    "click .collapse-toggle": -> toggleCollapse()