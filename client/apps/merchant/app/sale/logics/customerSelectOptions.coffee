formatCustomerSearch = (item) -> "#{item.name}" if item

selectedCustomer = (customerId)->
  if customer = Schema.customers.findOne(customerId)
    option =
      contactName: null
      contactPhone: null
      deliveryAddress: null
      deliveryDate: null
      comment: null

    if logics.sales.currentOrder.paymentsDelivery == 1
      option.contactName     = customer.name ? null
      option.contactPhone    = customer.phone ? null
      option.deliveryAddress = customer.address ? null
      option.comment         = 'giao trong ngay'

    option.buyer = customer._id
    option.tabDisplay = Helpers.respectName(customer.name, customer.gender)
  else
    console.log 'Sai customer'; return
  Order.update(logics.sales.currentOrder._id, {$set: option})



logics.sales.customerSelectOptions =
  query: (query) -> query.callback
    results: _.filter logics.sales.currentAllCustomers.fetch(), (item) ->
      unsignedTerm = Helpers.RemoveVnSigns query.term
      unsignedName = Helpers.RemoveVnSigns item.name

      unsignedName.indexOf(unsignedTerm) > -1
    text: 'name'
  initSelection: (element, callback) -> callback(logics.sales.currentOrderBuyer)
  formatSelection: formatCustomerSearch
  formatResult: formatCustomerSearch
  id: '_id'
  placeholder: 'CHỌN NGƯỜI MUA'
  changeAction: (e) -> selectedCustomer(e.added._id)
  reactiveValueGetter: -> logics.sales.currentOrderBuyer
