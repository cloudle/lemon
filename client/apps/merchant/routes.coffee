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

    logics.sales.syncSale()
    logics.sales.syncCurrentOrder()
    logics.sales.syncCurrentProduct()

    return {
      myProfile: logics.sales.myProfile
      myOption : logics.sales.myOption
      mySession: logics.sales.mySession

      currentOrder: logics.sales.currentOrder
      orderHistory: logics.sales.currentOrderHistory

      currentFinalPrice: logics.sales.finalPrice()

      tabOptions: logics.sales.tabOptions

      productSelectOptions: logics.sales.productSelectOptions

      productQualityOptions        : logics.sales.qualityOptions
      productPriceOptions          : logics.sales.priceOptions
      productDiscountCashOptions   : logics.sales.discountCashOptions
      productDiscountPercentOptions: logics.sales.discountPercentOptions


      customerSelectOptions: logics.sales.customerSelectOptions
    }
_.extend(saleRoute, merchantRouteBase)

lemon.addRoute [merchantDevRoute, metroSummaryRoute, saleRoute]