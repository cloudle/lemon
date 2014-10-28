formatPaymentMethodSearch = (item) -> "#{item.display}" if item

logics.sales.billDiscountSelectOptions =
  query: (query) -> query.callback
    results: Apps.Merchant.DiscountTypes
    text: 'id'
  initSelection: (element, callback) -> callback _.findWhere(Apps.Merchant.DiscountTypes, {_id: logics.sales.currentOrder?.billDiscount})
  formatSelection: formatPaymentMethodSearch
  formatResult: formatPaymentMethodSearch
  placeholder: 'CHỌN SẢN PTGD'
  minimumResultsForSearch: -1
  changeAction: (e) ->
    option = {billDiscount: e.added._id}
    option.discountCash = 0 if option.billDiscount
    option.discountPercent = 0 if option.billDiscount
    Order.update(logics.sales.currentOrder._id, {$set: option})
    logics.sales.reCalculateOrder(logics.sales.currentOrder._id)

  reactiveValueGetter: -> _.findWhere(Apps.Merchant.DiscountTypes, {_id: logics.sales.currentOrder?.billDiscount})
