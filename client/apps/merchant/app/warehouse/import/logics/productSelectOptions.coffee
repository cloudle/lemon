logics.imports.productSelectOptions = ->
  query: (query) -> query.callback
    results: _.filter Session.get('availableProducts'), (item) ->
      unsignedTerm = Helpers.RemoveVnSigns query.term
      unsignedName = Helpers.RemoveVnSigns item.name

      unsignedName.indexOf(unsignedTerm) > -1 || item.productCode.indexOf(unsignedTerm) > -1
    text: 'name'
  initSelection: (element, callback) -> callback(Schema.products.findOne(Session.get('currentImport')?.currentProduct) ? 'skyReset')
  formatSelection: formatImportProductSearch
  formatResult: formatImportProductSearch
  id: '_id'
  placeholder: 'CHỌN SẢN PHẨM'
#    minimumResultsForSearch: -1
  hotkey: 'return'
  changeAction: (e) -> reUpdateProduct(e.added._id)
  reactiveValueGetter: -> Session.get('currentImport')?.currentProduct  ? 'skyReset'