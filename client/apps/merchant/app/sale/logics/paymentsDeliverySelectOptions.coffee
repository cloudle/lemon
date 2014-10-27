formatPaymentMethodSearch = (item) -> "#{item.display}" if item

logics.sales.paymentsDeliverySelectOptions = ->
  query: (query) -> query.callback
    results: Sky.system.paymentsDeliveries
    text: 'id'
  initSelection: (element, callback) -> callback _.findWhere(Sky.system.paymentsDeliveries, {_id: logics.sales.currentOrder?.paymentsDelivery})
  formatSelection: formatPaymentMethodSearch
  formatResult: formatPaymentMethodSearch
  placeholder: 'CHỌN SẢN PTGD'
  minimumResultsForSearch: -1
  changeAction: (e) ->
    option =
      paymentsDelivery: e.added._id
    if e.added._id == 1
      if customer = Schema.customers.findOne(logics.sales.currentOrder.buyer)
        option.contactName     = customer.name ? null
        option.contactPhone    = customer.phone ? null
        option.deliveryAddress = customer.address ? null
        option.comment         = 'Giao trong ngày'
        option.deliveryDate    = new Date

        $("[name=deliveryDate]").datepicker('setDate', option.deliveryDate)
      else
        console.log 'Sai customer'; return
    Schema.orders.update(logics.sales.currentOrder._id, {$set: option})
  reactiveValueGetter: -> _.findWhere(Sky.system.paymentsDeliveries, {_id: logics.sales.currentOrder?.paymentsDelivery})
