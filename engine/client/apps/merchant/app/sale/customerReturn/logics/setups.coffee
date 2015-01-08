formatCustomerSearch = (item) ->
  if item
    name = "#{item.name} "
    desc = if item.description then "(#{item.description})" else ""
    name + desc
changedActionSelectCustomer = (customer, currentCustomerReturn)->
  Schema.returns.update currentCustomerReturn._id,
    $set: {
      customer: customer._id
      tabDisplay: Helpers.shortName2(customer.name)
    }
    ,
    $unset:{
      import: true
      timeLineImport: true
      distributor: true
    }

Apps.Merchant.customerReturnInit.push (scope) ->
  scope.customerSelectOptions =
    query: (query) -> query.callback
      results: _.filter Schema.customers.find().fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name

        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) -> callback(Schema.customers.findOne(Session.get('currentCustomerReturn')?.customer ? 'skyReset'))
    formatSelection: formatCustomerSearch
    formatResult: formatCustomerSearch
    id: '_id'
    placeholder: 'CHỌN NGƯỜI MUA'
    changeAction: (e) -> changedActionSelectCustomer(e.added, Session.get('currentCustomerReturn'))
    reactiveValueGetter: -> Session.get('currentCustomerReturn')?.customer ? 'skyReset'

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

  scope.updateCustomerReturnDetail = (returnDetail, template)->
    unitQuality = Math.abs(Helpers.Number(template.ui.$editQuality.inputmask('unmaskedvalue')))
    unitPrice   = Math.abs(Helpers.Number(template.ui.$editPrice.inputmask('unmaskedvalue')))
    totalPrice = unitQuality * unitPrice

    optionDetail =
      unitReturnQuality: unitQuality
      unitReturnsPrice: unitPrice
      returnQuality: returnDetail.conversionQuality * unitQuality
      price: unitPrice/returnDetail.conversionQuality
      totalPrice: totalPrice
      finalPrice: totalPrice

    Schema.returnDetails.update returnDetail._id, $set: optionDetail
    scope.reCalculateReturn(returnDetail.return)