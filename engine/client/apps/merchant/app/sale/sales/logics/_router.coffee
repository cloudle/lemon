scope = logics.sales

saleRoute =
  template: 'sales',
  waitOnDependency: 'merchantEssential'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.salesInit, 'sales')
      Session.set "currentAppInfo",
        name: "bán hàng"
        navigationPartial:
          template: "salesNavigationPartial"
          data: {}
      @next()
#      Apps.setup(scope, Apps.Merchant.salesReload)
  data: ->
    Apps.setup(scope, Apps.Merchant.salesReactiveRun)

    return {
      currentOrder: Session.get('currentOrder')
      saleDetails:
        order: Session.get('currentOrder')
        orderDetails: scope.currentOrderDetails
      currentOrderDetails: scope.currentOrderDetails
      orderHistory: scope.currentOrderHistory

      finalPriceProduct: scope.finalPriceProduct
      deliveryDetail   : scope.deliveryDetail
      currentDebit     : scope.currentDebit

      tabOptions        : scope.tabOptions
      saleDetailOptions : scope.saleDetailOptions

#      productSelectOptions         : scope.productSelectOptions
      productQualityOptions        : scope.qualityOptions
      productPriceOptions          : scope.priceOptions
      productDiscountCashOptions   : scope.discountCashOptions
      productDiscountPercentOptions: scope.discountPercentOptions

      billDiscountSelectOption   : scope.billDiscountSelectOptions
      billCashDiscountOptions    : scope.billCashDiscountOptions
      billPercentDiscountOptions : scope.billPercentDiscountOptions
      customerSelectOptions      : scope.customerSelectOptions
      depositOptions             : scope.depositOptions

      sellerSelectOptions          : scope.sellerSelectOptions
      paymentsDeliverySelectOption : scope.paymentsDeliverySelectOptions
      paymentMethodSelectOption    : scope.paymentMethodSelectOptions

      allProductInCurrentWarehouse : scope.managedSalesProductList
    }

lemon.addRoute [saleRoute], Apps.Merchant.RouterBase