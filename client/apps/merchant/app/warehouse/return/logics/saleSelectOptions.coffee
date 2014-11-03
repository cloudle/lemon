formatSaleReturnSearch = (item) -> "#{item.orderCode} #{}" if item

Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.saleSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.returns.availableSales?.fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.orderCode
        unsignedName.indexOf(unsignedTerm) > -1
      text: 'orderCode'
    initSelection: (element, callback) -> callback(logics.returns.currentSale ? 'skyReset')
    formatSelection: formatSaleReturnSearch
    formatResult: formatSaleReturnSearch
    id: '_id'
    placeholder: 'CHỌN PHIẾU BÁN HÀNG'
  #    minimumResultsForSearch: -1
    changeAction: (e) ->
      UserSession.set('currentSale', e.added._id)
#      Schema.userProfiles.update(Session.get('currentProfile')._id, {$set: {currentSale: e.added._id}})
#      sale = Schema.sales.findOne(e.added._id)
#      if !sale.currentProductDetail
#        saleDetail = Schema.saleDetails.findOne({sale: e.added._id})
#        Schema.sales.update(e.added._id, $set:{currentProductDetail: saleDetail._id, currentQuality: 1})
#        sale.currentProductDetail = saleDetail._id
#        sale.currentQuality       = 1
#      Session.set 'currentSale', sale
    reactiveValueGetter: -> logics.returns.currentSale ? 'skyReset'