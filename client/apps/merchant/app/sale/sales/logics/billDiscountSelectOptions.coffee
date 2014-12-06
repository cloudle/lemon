formatPaymentMethodSearch = (item) -> "#{item.display}" if item

changedActionSelectDiscountCash = (discount)->
  option = {billDiscount: discount}
  option.discountCash = 0 if option.billDiscount
  option.discountPercent = 0 if option.billDiscount
  Schema.orders.update(logics.sales.currentOrder._id, {$set: option})
  logics.sales.reCalculateOrder(logics.sales.currentOrder._id)

Apps.Merchant.salesInit.push ->
  logics.sales.billDiscountSelectOptions =
    query: (query) -> query.callback
      results: Apps.Merchant.DiscountTypes
      text: 'id'
    initSelection: (element, callback) ->
      callback _.findWhere(Apps.Merchant.DiscountTypes, {_id: Session.get('currentOrder')?.billDiscount})
    formatSelection: formatPaymentMethodSearch
    formatResult: formatPaymentMethodSearch
    placeholder: 'CHỌN SẢN PTGD'
    minimumResultsForSearch: -1
    changeAction: (e) -> changedActionSelectDiscountCash(e.added._id)
    reactiveValueGetter: -> _.findWhere(Apps.Merchant.DiscountTypes, {_id: Session.get('currentOrder')?.billDiscount})
