Apps.Merchant.salesInit.push ->
  logics.sales.saleDetailOptions =
    itemTemplate: 'saleProductThumbnail'
    reactiveSourceGetter: -> logics.sales.currentOrderDetails?.fetch() ? []
    wrapperClasses: 'detail-grid row'
