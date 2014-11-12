formatCustomerSearch = (item) -> "#{item.name}" if item

Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.customerSelectOptions =
    query: (query) -> query.callback
      results: _.filter Schema.customers.find({}).fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) -> callback(Schema.customers.findOne(Session.get('createNewTransaction').customerId) ? 'skyReset')
    reactiveValueGetter: -> Session.get('createNewTransaction').customerId ? 'skyReset'
    changeAction: (e) ->
      if e.added
        createNewTransaction = Session.get('createNewTransaction')
        createNewTransaction.customerId = e.added._id
        createNewTransaction.description = ''
        createNewTransaction.maxCash = 90000000000
        Session.set('createNewTransaction', createNewTransaction)
        $("[name=debtDate]").datepicker('setDate', new Date)
      else
        createNewTransaction = Session.get('createNewTransaction')
        createNewTransaction.customerId = 'skyReset'
        createNewTransaction.description = ''
        createNewTransaction.maxCash = 0
        Session.set('createNewTransaction', createNewTransaction)
        $("[name=debtDate]").datepicker('setDate', undefined)

    placeholder: 'CHỌN NGƯỜI MUA'
    formatSelection: formatCustomerSearch
    formatResult: formatCustomerSearch
    others:
      allowClear: true
