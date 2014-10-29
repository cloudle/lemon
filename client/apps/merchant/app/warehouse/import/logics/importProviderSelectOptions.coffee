formatProviderSearch = (item) -> "#{item.name}" if item

logics.import.importProviderSelectOptions =
  query: (query) -> query.callback
    results: _.filter logics.import.branchProviders?.fetch(), (item) ->
      unsignedTerm = Helpers.RemoveVnSigns query.term
      unsignedName = Helpers.RemoveVnSigns item.name
      unsignedName.indexOf(unsignedTerm) > -1
    text: 'name'
  initSelection: (element, callback) -> callback(logics.import.currentProvider ? 'skyReset')
  formatSelection: formatProviderSearch
  formatResult: formatProviderSearch
  id: '_id'
  placeholder: 'CHỌN NHÀ CUNG CẤP'
  others:
    allowClear: true
#    minimumResultsForSearch: -1
  changeAction: (e) ->
#    if e.added
#      Schema.imports.update(Session.get('currentImport')._id, {$set: {currentProvider: e.added._id }})
#      Schema.products.update(Session.get('currentProductInstance')._id, {$set:{provider: e.added._id}})
#    else
#      Schema.imports.update(Session.get('currentImport')._id, {$set: {currentProvider: 'skyReset' }})
#      Schema.products.update(Session.get('currentProductInstance')._id, {$set:{provider: 'skyReset'}})


  reactiveValueGetter: -> logics.import.currentProvider ? 'skyReset'