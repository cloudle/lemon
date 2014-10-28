formatProductSearch = (item) -> "#{item.name} [#{item.skulls}]" if item

updateSelectNewProduct = (product)->
  Schema.orders.update logics.sales.currentOrder._id,
    $set:
      currentProduct        : product._id
      currentQuality        : Number(1)
      currentPrice          : product.price
      currentDiscountCash   : Number(0)
      currentDiscountPercent: Number(0)

logics.sales.productSelectOptions =
  query: (query) -> query.callback
    results: _.filter logics.sales.currentWarehouseProducts.fetch(), (item) ->
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
    logics.sales.createNewOrderAndSelected()
    updateSelectNewProduct(e.added)
#    Session.set('allowAllOrderDetail', true) unless Session.get('allowAllOrderDetail')
  reactiveValueGetter: -> logics.sales.currentProduct


