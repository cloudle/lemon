formatTimesUseProductSearch = (item) -> "#{item.display}" if item

updateImportAndProduct = (e)->

Apps.Merchant.importInit.push (scope) ->
  logics.import.timeUseSelectOptions =
    query: (query) -> query.callback
      results: Apps.Merchant.TimesUseProduct
      text: 'id'
    initSelection: (element, callback) -> callback(_.findWhere(Apps.Merchant.TimesUseProduct, {timeDate: Session.get('timesUseProduct')}) ? 'skyReset')
    formatSelection: formatTimesUseProductSearch
    formatResult: formatTimesUseProductSearch
    placeholder: 'CHỌN HẠN DÙNG'
    minimumResultsForSearch: -1
    changeAction: (e) -> Session.set('timesUseProduct', e.added.timeDate)
    reactiveValueGetter: -> _.findWhere(Apps.Merchant.TimesUseProduct, {timeDate: Session.get('timesUseProduct')})?._id ? 'skyReset'
