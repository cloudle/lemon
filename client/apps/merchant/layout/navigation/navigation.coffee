lemon.defineApp Template.navigation,
  unreadMessageCount: -> logics.merchantNotification.unreadMessages.count()
  unreadNotifiesCount: -> logics.merchantNotification.unreadNotifies.count()
  unreadRequestCount: -> logics.merchantNotification.unreadRequests.count()
  subMenus: -> Session.get('subMenus')
  tourVisible: -> true #Session.get('currentTourName') is ''
  navigationPartial: -> Session.get("currentAppInfo")?.navigationPartial
  isntMerchantHome: -> Router.current().url isnt '/merchant'
  appInfo: ->
    return {
      navigationPartial : Session.get("currentAppInfo")?.navigationPartial
      color             : Session.get("currentAppInfo")?.color ? 'white'
    }

  events:
    "click #logoutButton": (event, template) -> lemon.logout('/')
    "click a.branding": -> Session.set('autoNatigateDashboardOff', true); Router.go('/')
    "click .home": -> Router.go('/merchant')
    "click .tour-toggle": -> Apps.currentTour?.restart()