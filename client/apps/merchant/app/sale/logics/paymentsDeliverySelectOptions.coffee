formatPaymentMethodSearch = (item) -> "#{item.display}" if item

changedActionSelectPaymentsDelivery = (paymentsDelivery, currentOrder)->
  option = {paymentsDelivery: paymentsDelivery}
  if e.added._id == 1
    if customer = Schema.customers.findOne(currentOrder.buyer)
      option.contactName     = customer.name ? null
      option.contactPhone    = customer.phone ? null
      option.deliveryAddress = customer.address ? null
      option.comment         = 'Giao trong ngày'
      option.deliveryDate    = new Date

#      $("[name=deliveryDate]").datepicker('setDate', option.deliveryDate)
    else console.log 'Sai customer'; return
  Schema.orders.update(currentOrder._id, {$set: option})


logics.sales.paymentsDeliverySelectOptions =
  query: (query) -> query.callback
    results: Apps.Merchant.DeliveryTypes
    text: 'id'
  initSelection: (element, callback) ->
    callback _.findWhere(Apps.Merchant.DeliveryTypes, {_id: logics.sales.currentOrder?.paymentsDelivery})
  formatSelection: formatPaymentMethodSearch
  formatResult: formatPaymentMethodSearch
  placeholder: 'CHỌN SẢN PTGD'
  minimumResultsForSearch: -1
  changeAction: (e) -> changedActionSelectPaymentsDelivery(e.added._id, logics.sales.currentOrder)
  reactiveValueGetter: -> _.findWhere(Apps.Merchant.DeliveryTypes, {_id: logics.sales.currentOrder?.paymentsDelivery})
