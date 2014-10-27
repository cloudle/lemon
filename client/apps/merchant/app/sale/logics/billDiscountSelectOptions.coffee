formatPaymentMethodSearch = (item) -> "#{item.display}" if item

logics.sales.billDiscountSelectOptions = (event, template) ->
  query: (query) -> query.callback
    results: Sky.system.billDiscounts
    text: 'id'
  initSelection: (element, callback) -> callback _.findWhere(Sky.system.billDiscounts, {_id: logics.sales.currentOrder?.billDiscount})
  formatSelection: formatPaymentMethodSearch
  formatResult: formatPaymentMethodSearch
  placeholder: 'CHỌN SẢN PTGD'
  minimumResultsForSearch: -1
  changeAction: (e) ->
    order = Order.findOne(logics.sales.currentOrder._id)
    option = {billDiscount: e.added._id}
    option.discountCash = 0 if option.billDiscount
    option.discountPercent = 0 if option.billDiscount
    Schema.orders.update(logics.sales.currentOrder._id, {$set: option})
    Sky.global.reCalculateOrder(logics.sales.currentOrder._id)

  reactiveValueGetter: -> _.findWhere(Sky.system.billDiscounts, {_id: logics.sales.currentOrder?.billDiscount})
