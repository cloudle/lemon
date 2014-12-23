formatPaymentMethodSearch = (item) -> "#{item.display}" if item
formatCustomerSearch = (item) ->
  if item
    name = "#{item.name} "
    desc = if item.description then "(#{item.description})" else ""
    name + desc


changedActionSelectCustomer = (customerId, currentReturn)-> Schema.returns.update currentReturn._id, $set: {customer: customerId}

changedActionSelectReturnMethods = (returnMethods, currentReturn)->
  if returnMethods is 0
    Schema.returns.update currentReturn._id, $set: {returnMethods  : 0}, $unset:{
      import: true
      timeLineImport: true
      distributor: true
    }

  if returnMethods is 1
    Schema.returns.update currentReturn._id, $set: {returnMethods  : 1}, $unset:{
      sale: true
      timeLineSales: true
      customer: true
    }


Apps.Merchant.returnManagementInit.push (scope) ->
  scope.currentReturnHistory = Schema.returns.find().fetch()
  scope.currentReturnDetails = Schema.returnDetails.find({return: Session.get('currentReturn')?._id}).fetch()

  scope.distributorSelectOptions =
    query: (query) -> query.callback
      results: _.filter Schema.customers.find().fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name

        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) -> callback(Schema.customers.findOne(Session.get('currentReturn')?.customer ? 'skyReset'))
    formatSelection: formatCustomerSearch
    formatResult: formatCustomerSearch
    id: '_id'
    placeholder: 'CHỌN NHÀ CC'
    changeAction: (e) -> changedActionSelectCustomer(e.added._id, Session.get('currentReturn'))
    reactiveValueGetter: -> Session.get('currentReturn')?.customer ? 'skyReset'

  scope.customerSelectOptions =
    query: (query) -> query.callback
      results: _.filter Schema.customers.find().fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name

        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) -> callback(Schema.customers.findOne(Session.get('currentReturn')?.customer ? 'skyReset'))
    formatSelection: formatCustomerSearch
    formatResult: formatCustomerSearch
    id: '_id'
    placeholder: 'CHỌN NGƯỜI MUA'
    changeAction: (e) -> changedActionSelectCustomer(e.added._id, Session.get('currentReturn'))
    reactiveValueGetter: -> Session.get('currentReturn')?.customer ? 'skyReset'

  scope.returnSelectOptions =
    query: (query) -> query.callback
      results: Apps.Merchant.ReturnMethods
      text: 'id'
    initSelection: (element, callback) ->
      callback _.findWhere(Apps.Merchant.ReturnMethods, {_id: Session.get('currentReturn')?.returnMethods})
    formatSelection: formatPaymentMethodSearch
    formatResult: formatPaymentMethodSearch
    placeholder: 'CHỌN PHƯƠNG THỨC TRẢ'
    minimumResultsForSearch: -1
    changeAction: (e) -> changedActionSelectReturnMethods(e.added._id, Session.get('currentReturn'))
    reactiveValueGetter: -> _.findWhere(Apps.Merchant.ReturnMethods, {_id:Session.get('currentReturn')?.returnMethods})

  scope.reCalculateReturn = (returnId)->
    totalPrice = 0
    discountCash = 0
    Schema.returnDetails.find({return: returnId}).forEach(
      (detail)->
        totalPrice += detail.unitReturnQuality * detail.unitReturnsPrice
        discountCash += detail.discountCash
    )
    Schema.returns.update returnId, $set:{
      discountCash    : discountCash
      totalPrice      : totalPrice
      discountPercent : if discountCash > 0 then discountCash/(totalPrice/100) else 0
      finallyPrice    : totalPrice - discountCash
      debtBalanceChange: totalPrice - discountCash
    }

