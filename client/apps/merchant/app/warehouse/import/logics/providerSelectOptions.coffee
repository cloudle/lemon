formatProviderSearch = (item) -> "#{item.name}" if item

updateImportAndProduct = (e)->
  if e.added
    Import.update(Session.get('currentImport')._id, {$set: {currentProvider: e.added._id }})
    Product.update(Session.get('currentImport').currentProduct, {$set:{provider: e.added._id}})
  else
    Import.update(Session.get('currentImport')._id, {$set: {currentProvider: 'skyReset' }})
    Product.update(Session.get('currentImport').currentProduct, {$set:{provider: 'skyReset'}})


Apps.Merchant.importInit.push (scope) ->
  logics.import.providerSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.import.branchProviders.fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) ->
      callback(Schema.providers.findOne(Session.get('currentImport')?.currentProvider) ? 'skyReset')
    formatSelection: formatProviderSearch
    formatResult: formatProviderSearch
    id: '_id'
    placeholder: 'CHỌN NHÀ CUNG CẤP'
    others:
      allowClear: true
  #    minimumResultsForSearch: -1
    changeAction: (e) -> updateImportAndProduct(e)
    reactiveValueGetter: -> Session.get('currentImport')?.currentProvider ? 'skyReset'