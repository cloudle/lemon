saleRoute =
  template: 'sales',
  waitOnDependency: 'saleOrder'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.sales, Apps.Merchant.salesInit, 'sales')
      @next()
#      Apps.setup(logics.sales, Apps.Merchant.salesReload)
  data: ->
    Apps.setup(logics.sales, Apps.Merchant.salesReactiveRun)

    return {
      currentOrder: logics.sales.currentOrder
      currentOrderDetails: logics.sales.currentOrderDetails
      orderHistory: logics.sales.currentOrderHistory

      finalPriceProduct: logics.sales.finalPriceProduct
      deliveryDetail   : logics.sales.deliveryDetail
      currentDebit     : logics.sales.currentDebit

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

lemon.addRoute [saleRoute], Apps.Merchant.RouterBase
