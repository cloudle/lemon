formatCustomerSearch = (item) -> "#{item.name}" if item

logics.sales.customerSelectOptions =
  query: (query) -> query.callback
    results: _.filter logics.sales.currentAllCustomers.fetch(), (item) ->
      unsignedTerm = Sky.helpers.removeVnSigns query.term
      unsignedName = Sky.helpers.removeVnSigns item.name

      unsignedName.indexOf(unsignedTerm) > -1
    text: 'name'
  initSelection: (element, callback) -> callback(Schema.customers.findOne(logics.sales.currentOrder?.buyer))
  formatSelection: formatCustomerSearch
  formatResult: formatCustomerSearch
  id: '_id'
  placeholder: 'CHỌN NGƯỜI MUA'
  changeAction: (e) ->
    if customer = Schema.customers.findOne(e.added._id)
      option =
        contactName: null
        contactPhone: null
        deliveryAddress: null
        deliveryDate: null
        comment: null

      if logics.sales.currentOrder?.paymentsDelivery == 1
        option.contactName     = customer.name ? null
        option.contactPhone    = customer.phone ? null
        option.deliveryAddress = customer.address ? null
      option.buyer = customer._id
      option.tabDisplay = Sky.helpers.respectName(customer.name, customer.gender)
    else
      console.log 'Sai customer'; return
    Schema.orders.update(logics.sales.currentOrder._id, {$set: option})

  reactiveValueGetter: -> logics.sales.currentOrder?.buyer
