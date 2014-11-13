formatSaleReturnSearch = (item) ->
  if item.status then "#{item.orderCode} [Chưa trả] "
  else "#{item.orderCode} [Đang trả] "

Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.saleSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.returns.availableSales.fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.orderCode
        unsignedName.indexOf(unsignedTerm) > -1
      text: 'orderCode'
    initSelection: (element, callback) -> callback(logics.returns.currentSale ? 'skyReset')
    reactiveValueGetter: -> logics.returns.currentSale ? 'skyReset'
    changeAction: (e) ->
      UserSession.set('currentSale', e.added._id)
      if !(Schema.sales.findOne(e.added._id)).currentProductDetail
        if saleDetail = Schema.saleDetails.findOne({sale: e.added._id})
          Schema.sales.update(e.added._id, $set:{currentProductDetail: saleDetail._id, currentQuality: 1})

    formatSelection: formatSaleReturnSearch
    formatResult: formatSaleReturnSearch
    id: '_id'
    placeholder: 'CHỌN PHIẾU BÁN HÀNG'
  #    minimumResultsForSearch: -1


