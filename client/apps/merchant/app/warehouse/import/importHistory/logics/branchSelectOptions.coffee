formatMerchantSearch = (item) -> "#{item.name}" if item

Apps.Merchant.importHistoryInit.push (scope) ->
  scope.branchSelectOptions =
    query: (query) -> query.callback
      results: scope.availableMerchants.fetch()
    initSelection: (element, callback) -> callback(scope.currentMerchant ? 'skyReset')
    reactiveValueGetter: -> scope.currentMerchant._id ? 'skyReset'
    changeAction: (e) -> scope.currentMerchant = e.added; UserSession.set('currentImportMerchant', e.added._id)
    minimumResultsForSearch: -1
    formatSelection: formatMerchantSearch
    formatResult: formatMerchantSearch
    placeholder: 'CHỌN CHI NHÁNH'