formatSellerSearch = (item) -> "#{item.emails[0].address}" if item

logics.sales.sellerSelectOptions = ->
  query: (query) -> query.callback
  results: _.filter Session.get("availableStaffSale"), (item) ->
    result = false
    for email in item.emails
      if email.address.indexOf(query.term) > -1 then (result = true; break)
    result
  text: 'email'
  initSelection: (element, callback) ->
    currentSeller = logics.sales.currentOrder?.seller ? Meteor.userId()
    callback Meteor.users.findOne(currentSeller)
  formatSelection: formatSellerSearch
  formatResult: formatSellerSearch
  id: '_id'
  placeholder: 'CHỌN NGƯỜI BÁN'
  changeAction: (e) -> Schema.orders.update(logics.sales.currentOrder._id, {$set: {seller: e.added._id}})
  reactiveValueGetter: -> logics.sales.currentOrder?.seller
