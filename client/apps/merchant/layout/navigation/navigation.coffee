lemon.defineApp Template.navigation,
  unreadMessageCount: -> logics.merchantNotification.unreadMessages.count()
  unreadNotifiesCount: -> logics.merchantNotification.unreadNotifies.count()
  unreadRequestCount: -> logics.merchantNotification.unreadRequests.count()
  subMenus: -> Session.get('subMenus')
  tourVisible: -> true #Session.get('currentTourName') is ''

  events:
    "click #logoutButton": (event, template) -> lemon.logout('/')
    "click a.branding": -> Session.set('autoNatigateDashboardOff', true); Router.go('/')
    "click .tour-toggle": -> Apps.currentTour?.restart()