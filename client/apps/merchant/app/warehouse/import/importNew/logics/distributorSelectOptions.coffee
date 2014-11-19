formatDistributorSearch = (item) -> "#{item.name}" if item

updateImportAndProduct = (e)->
  if e.added
    Schema.imports.update(Session.get('currentImport')._id, {$set: {currentDistributor: e.added._id }})
  else
    Schema.imports.update(Session.get('currentImport')._id, {$set: {currentDistributor: 'skyReset' }})

Apps.Merchant.importInit.push (scope) ->
  logics.import.distributorSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.import.availableDistributor.fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) ->
      callback(Schema.distributors.findOne(Session.get('currentImport')?.currentDistributor) ? 'skyReset')
    formatSelection: formatDistributorSearch
    formatResult: formatDistributorSearch
    id: '_id'
    placeholder: 'CHỌN NHÀ PHÂN PHỐI'
  #    minimumResultsForSearch: -1
    changeAction: (e) -> updateImportAndProduct(e)
    reactiveValueGetter: -> Session.get('currentImport')?.currentDistributor ? 'skyReset'