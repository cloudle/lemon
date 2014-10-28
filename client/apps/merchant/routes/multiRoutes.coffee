merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }
_.extend(merchantDevRoute, Merchant.merchantRouteBase)

metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Merchant.Subscriber)
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(metroSummaryRoute, Merchant.merchantRouteBase)

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
    logics.sales.syncCurrentOrderDetails()
    logics.sales.syncProductAndSellerAndBuyer()


    return {
      myProfile: logics.sales.myProfile
      myOption : logics.sales.myOption
      mySession: logics.sales.mySession

      currentOrder: logics.sales.currentOrder
      orderHistory: logics.sales.currentOrderHistory

      currentFinalPrice: logics.sales.finalPrice()
      deliveryDetail   : logics.sales.deliveryDetail()
      currentDebit     : logics.sales.currentDebit()

      tabOptions        : logics.sales.tabOptions
      saleDetailOptions : logics.sales.saleDetailOptions

      productSelectOptions         : logics.sales.productSelectOptions
      productQualityOptions        : logics.sales.qualityOptions
      productPriceOptions          : logics.sales.priceOptions
      productDiscountCashOptions   : logics.sales.discountCashOptions
      productDiscountPercentOptions: logics.sales.discountPercentOptions

      billDiscountSelectOption   : logics.sales.billDiscountSelectOptions
      billCashDiscountOptions    : logics.sales.billCashDiscountOptions
      billPercentDiscountOptions : logics.sales.billPercentDiscountOptions
      customerSelectOptions      : logics.sales.customerSelectOptions
      depositOptions             : logics.sales.depositOptions

      sellerSelectOptions          : logics.sales.sellerSelectOptions
      paymentsDeliverySelectOption : logics.sales.paymentsDeliverySelectOptions
      paymentMethodSelectOption    : logics.sales.paymentMethodSelectOptions



    }
_.extend(saleRoute, Merchant.merchantRouteBase)

lemon.addRoute [merchantDevRoute, metroSummaryRoute, saleRoute]