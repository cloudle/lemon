formatPaymentMethodSearch = (item) -> "#{item.display}" if item

changedActionSelectPaymentsDelivery = (paymentsDelivery, currentOrder)->
  option = {paymentsDelivery: paymentsDelivery}
  if paymentsDelivery == 1
    if customer = Schema.customers.findOne(currentOrder.buyer)
      option.contactName     = customer.name ? null
      option.contactPhone    = customer.phone ? null
      option.deliveryAddress = customer.address ? null
      option.comment         = 'Giao trong ngày'
      option.deliveryDate    = new Date

      $("[name=deliveryDate]").datepicker('setDate', option.deliveryDate)
    else console.log 'Không tìm thấy khách hàng.'; return
  Schema.orders.update(currentOrder._id, {$set: option})

Apps.Merchant.salesInit.push ->
  logics.sales.paymentsDeliverySelectOptions =
    query: (query) -> query.callback
      results: Apps.Merchant.DeliveryTypes
      text: 'id'
    initSelection: (element, callback) ->
      callback _.findWhere(Apps.Merchant.DeliveryTypes, {_id: Session.get('currentOrder')?.paymentsDelivery})
    formatSelection: formatPaymentMethodSearch
    formatResult: formatPaymentMethodSearch
    placeholder: 'CHỌN SẢN PTGD'
    minimumResultsForSearch: -1
    changeAction: (e) -> changedActionSelectPaymentsDelivery(e.added._id, Session.get('currentOrder'))
    reactiveValueGetter: -> _.findWhere(Apps.Merchant.DeliveryTypes, {_id: Session.get('currentOrder')?.paymentsDelivery})
