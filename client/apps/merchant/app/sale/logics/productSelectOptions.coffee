formatProductSearch = (item) -> "#{item.name} [#{item.skulls}]" if item

updateSelectNewProduct = (product, orderId)->
  Order.update orderId,
    $set:
      currentProduct        : product._id
      currentQuality        : Number(1)
      currentPrice          : product.price
      currentDiscountCash   : Number(0)
      currentDiscountPercent: Number(0)

logics.sales.productSelectOptions =
  query: (query) -> query.callback
    results: _.filter logics.sales.currentAllProductsInWarehouse.fetch(), (item) ->
      unsignedTerm = Helpers.RemoveVnSigns query.term
      unsignedName = Helpers.RemoveVnSigns item.name

      unsignedName.indexOf(unsignedTerm) > -1 || item.productCode.indexOf(unsignedTerm) > -1
    text: 'name'
  initSelection: (element, callback) -> callback logics.sales.currentProduct
  formatSelection: formatProductSearch
  formatResult: formatProductSearch
  placeholder: 'CHỌN SẢN PHẨM'
  minimumResultsForSearch: -1
  changeAction: (e) ->
    orderId = logics.sales.createNewOrderAndSelected()
    updateSelectNewProduct(e.added, orderId)
    Session.set('allowAllOrderDetail', true) unless Session.get('allowAllOrderDetail')
  reactiveValueGetter: -> logics.sales.currentProduct


