formatProductSearch = (item) -> "#{item.name} [#{item.skulls}]" if item

logics.import.importProductSelectOptions =
  query: (query) -> query.callback
    results: _.filter logics.import.productsInWarehouse?.fetch(), (item) ->
      unsignedTerm = Helpers.RemoveVnSigns query.term
      unsignedName = Helpers.RemoveVnSigns item.name

      unsignedName.indexOf(unsignedTerm) > -1 || item.productCode.indexOf(unsignedTerm) > -1
    text: 'name'
  initSelection: (element, callback) -> callback(logics.import.currentProduct ? 'skyReset')
  formatSelection: formatProductSearch
  formatResult: formatProductSearch
  id: '_id'
  placeholder: 'CHỌN SẢN PHẨM'
#    minimumResultsForSearch: -1
  hotkey: 'return'
  changeAction: (e) ->
  reactiveValueGetter: -> logics.import.currentProduct  ? 'skyReset'