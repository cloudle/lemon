formatDistributorSearch = (item) ->
  if item
    name = "#{item.name} "
    desc = if item.description then "(#{item.description})" else ""
    name + desc

changedActionSelectDistributor = (distributor, currentDistributorReturn)->
  Schema.returns.update currentDistributorReturn._id,
    $set: {
      distributor: distributor._id
      tabDisplay: Helpers.shortName2(distributor.name)
    }
    ,
    $unset: {
      sale: true
      timeLineSales: true
      customer: true
    }

Apps.Merchant.distributorReturnInit.push (scope) ->
  scope.distributorSelectOptions =
    query: (query) -> query.callback
      results: _.filter Schema.distributors.find().fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name

        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) -> callback(Schema.distributors.findOne(Session.get('currentDistributorReturn')?.distributor ? 'skyReset'))
    formatSelection: formatDistributorSearch
    formatResult: formatDistributorSearch
    id: '_id'
    placeholder: 'CHỌN NHÀ CC'
    changeAction: (e) -> changedActionSelectDistributor(e.added, Session.get('currentDistributorReturn'))
    reactiveValueGetter: -> Session.get('currentDistributorReturn')?.distributor ? 'skyReset'

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

  scope.updateDistributorReturnDetail = (returnDetail, template)->
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