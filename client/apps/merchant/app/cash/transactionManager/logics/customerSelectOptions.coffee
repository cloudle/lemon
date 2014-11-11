formatCustomerSearch = (item) -> "#{item.name}" if item

Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.customerSelectOptions =
    query: (query) -> query.callback
      results: _.filter Schema.customers.find({}).fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) -> callback(Schema.customers.findOne())
    formatSelection: formatCustomerSearch
    formatResult: formatCustomerSearch
    id: '_id'
    placeholder: 'CHỌN NGƯỜI MUA'
    changeAction: (e) -> scope.createTransactionCustomer = e.added._id
    reactiveValueGetter: -> 'skyReset'
