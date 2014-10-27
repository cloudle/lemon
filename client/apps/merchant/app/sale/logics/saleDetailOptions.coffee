logics.sales.saleDetailOptions = ->
  itemTemplate: 'saleProductThumbnail'
  reactiveSourceGetter: -> Session.get('currentOrderDetails')
  wrapperClasses: 'detail-grid row'
