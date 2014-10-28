formatProductSearch = (item) -> "#{item.name} [#{item.skulls}]" if item

logics.sales.productSelectOptions =
  query: (query) -> query.callback
  results: _.filter Session.get('availableSaleProducts'), (item) ->
    unsignedTerm = Helpers.RemoveVnSigns query.term
    unsignedName = Helpers.RemoveVnSigns item.name

    unsignedName.indexOf(unsignedTerm) > -1 || item.productCode.indexOf(unsignedTerm) > -1
  text: 'name'
  initSelection: (element, callback) -> callback(Schema.products.findOne(logics.sales.currentOrder?.currentProduct))
  formatSelection: formatProductSearch
  formatResult: formatProductSearch
  id: '_id'
  placeholder: 'CHỌN SẢN PHẨM'
#    minimumResultsForSearch: -1
  hotkey: 'return'
  changeAction: (e) ->

    unless logics.sales.currentOrder then Session.set('currentOrder', Order.createOrderAndSelect())
    Schema.orders.update logics.sales.currentOrder._id,
      $set:
        currentProduct        : e.added._id
        currentQuality        : Number(1)
        currentPrice          : e.added.price
        currentDiscountCash   : Number(0)
        currentDiscountPercent: Number(0)
    Session.set('allowAllOrderDetail', true) unless Session.get('allowAllOrderDetail')

  reactiveValueGetter: -> logics.sales.currentOrder?.currentProduct