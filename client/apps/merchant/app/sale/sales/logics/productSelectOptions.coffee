#formatProductSearch = (item) -> "#{item.name} [#{item.skulls}]" if item
#updateSelectNewProduct = (scope, product, orderId)->
#  cross = scope.validation.getCrossProductQuality(product._id, orderId)
#  maxQuality = (cross.product.availableQuality - cross.quality)
#  Schema.orders.update orderId,
#    $set:
#      currentProduct        : product._id
#      currentQuality        : if maxQuality > 0 then 1 else 0
#      currentPrice          : product.price
#      currentTotalPrice     : product.price
#      currentDiscountCash   : Number(0)
#      currentDiscountPercent: Number(0)
#
#
#Apps.Merchant.salesInit.push (scope) ->
#  logics.sales.productSelectOptions =
#    query: (query) -> query.callback
#      results: _.filter logics.sales.currentAllProductsInWarehouse.fetch(), (item) ->
#        unsignedTerm = Helpers.RemoveVnSigns query.term
#        unsignedName = Helpers.RemoveVnSigns item.name
#
#        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode.indexOf(unsignedTerm) > -1
#      text: 'name'
#    initSelection: (element, callback) -> callback Schema.products.findOne(Session.get('currentOrder')?.currentProduct)
#    formatSelection: formatProductSearch
#    formatResult: formatProductSearch
#    placeholder: 'CHỌN SẢN PHẨM'
##    minimumResultsForSearch: -1
#    changeAction: (e) ->
#      if Session.get('currentOrder')
#        orderId = Session.get('currentOrder')._id
#      else
#        orderId = logics.sales.createNewOrderAndSelected()
#      updateSelectNewProduct(scope, e.added, orderId)
#      Session.set('allowCreateOrderDetail', true) unless Session.get('allowCreateOrderDetail')
#    reactiveValueGetter: -> Session.get('currentOrder')?.currentProduct
#
#
