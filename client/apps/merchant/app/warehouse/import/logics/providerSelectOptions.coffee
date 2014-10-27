logics.imports.providerSelectOptions = ->
  query: (query) -> query.callback
    results: _.filter Session.get('availableProviders'), (item) ->
      unsignedTerm = Sky.helpers.removeVnSigns query.term
      unsignedName = Sky.helpers.removeVnSigns item.name
      unsignedName.indexOf(unsignedTerm) > -1
    text: 'name'
  initSelection: (element, callback) -> callback(Schema.providers.findOne(Session.get('currentImport')?.currentProvider) ? 'skyReset')
  formatSelection: formatImportProviderSearch
  formatResult: formatImportProviderSearch
  id: '_id'
  placeholder: 'CHỌN NHÀ CUNG CẤP'
  others:
    allowClear: true
#    minimumResultsForSearch: -1
  changeAction: (e) ->
    if e.added
      Schema.imports.update(Session.get('currentImport')._id, {$set: {currentProvider: e.added._id }})
      Schema.products.update(Session.get('currentProductInstance')._id, {$set:{provider: e.added._id}})
    else
      Schema.imports.update(Session.get('currentImport')._id, {$set: {currentProvider: 'skyReset' }})
      Schema.products.update(Session.get('currentProductInstance')._id, {$set:{provider: 'skyReset'}})


  reactiveValueGetter: -> Session.get('currentImport')?.currentProvider ? 'skyReset'