formatSellerSearch = (item) -> "#{item.emails[0].address}" if item
Apps.Merchant.salesInit.push ->
  logics.sales.sellerSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.sales.currentBranchStaff?.fetch(), (item) ->
        result = false
        for email in item.emails
          if email.address.indexOf(query.term) > -1 then (result = true; break)
        result
      text: 'email'
    initSelection: (element, callback) ->
      currentSeller = Session.get('currentOrder')?.seller ? Meteor.userId()
      callback Meteor.users.findOne(currentSeller)
    formatSelection: formatSellerSearch
    formatResult: formatSellerSearch
    id: '_id'
    placeholder: 'CHỌN NGƯỜI BÁN'
    changeAction: (e) -> Order.update(Session.get('currentOrder')._id, {$set: {seller: e.added._id}})
    reactiveValueGetter: -> Session.get('currentOrder')?.seller
