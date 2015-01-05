formatPaymentMethodSearch = (item) -> "#{item.display}" if item

changedActionSelectPaymentMethod = (paymentMethod, currentOrder)->
  if paymentMethod is 0
    option =
      paymentMethod  : paymentMethod
      currentDeposit : currentOrder.finalPrice
      deposit        : currentOrder.finalPrice
      debit          : 0
  if paymentMethod is 1
    option =
      paymentMethod  : paymentMethod
      currentDeposit : 0
      deposit        : 0
      debit          : currentOrder.finalPrice
  Schema.orders.update(currentOrder._id, {$set: option})

Apps.Merchant.salesInit.push ->
  logics.sales.paymentMethodSelectOptions =
    query: (query) -> query.callback
      results: Apps.Merchant.PaymentMethods
      text: 'id'
    initSelection: (element, callback) ->
      callback _.findWhere(Apps.Merchant.PaymentMethods, {_id: Session.get('currentOrder')?.paymentMethod})
    formatSelection: formatPaymentMethodSearch
    formatResult: formatPaymentMethodSearch
    placeholder: 'CHỌN SẢN PTGD'
    minimumResultsForSearch: -1
    changeAction: (e) -> changedActionSelectPaymentMethod(e.added._id, Session.get('currentOrder'))
    reactiveValueGetter: -> _.findWhere(Apps.Merchant.PaymentMethods, {_id:Session.get('currentOrder')?.paymentMethod})

