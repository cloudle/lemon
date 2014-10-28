merchantRouteBase =
  layoutTemplate: 'merchantLayout'
  fastRender: true
  onAfterAction: ->
    Helpers.animateUsing("#container", "bounceInDown")

merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }
_.extend(merchantDevRoute, merchantRouteBase)

metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Merchant.Subscriber)
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(metroSummaryRoute, merchantRouteBase)

saleRoute =
  layoutTemplate: 'merchantLayout',
  template: 'sales',
  fastRender: true,
  waitOn: -> lemon.dependencies.resolve('order')
  data: ->
    logics.sales.syncMyProfile()
    logics.sales.syncMyOption()
    logics.sales.syncMySession()

    logics.sales.syncCurrentWarehouseProducts()
    logics.sales.syncCurrentAllSkulls()
    logics.sales.syncCurrentAllProviders()
    logics.sales.syncCurrentOrderHistory()
    logics.sales.syncCurrentOrder()
    logics.sales.syncCurrentOrderDetails()
    logics.sales.syncCurrentOrderBuyer()
    logics.sales.syncCurrentBranchStaff()
    logics.sales.syncCurrentOrderSeller()

    return {
      myProfile: logics.sales.myProfile
      myOption : logics.sales.myOption
      mySession: logics.sales.mySession

      currentOrder: logics.sales.currentOrder
      orderHistory: logics.sales.currentOrderHistory
      productSelectOptions: logics.sales.productSelectOptions
      qualityOptions: logics.sales.qualityOptions
    }
_.extend(saleRoute, merchantRouteBase)

lemon.addRoute [merchantDevRoute, metroSummaryRoute, saleRoute]