formatDistributorSearch = (item) -> "#{item.name}" if item

updateImportAndProduct = (e)->
  if e.added
    if e.added.merchantType then importUpdate = {$set: {partner: e.added._id}, $unset: {distributor: true}}
    else importUpdate = {$set: {distributor: e.added._id}, $unset: {partner: true}}
    importUpdate.$set.tabDisplay = Helpers.shortName2(e.added.name)
  else
    importUpdate = { $set:{tabDisplay: 'Nhập kho'}, $unset:{distributor: true, partner: true} }
  Schema.imports.update Session.get('currentImport')._id, importUpdate

Apps.Merchant.importInit.push (scope) ->
  logics.import.distributorSelectOptions =
    query: (query) -> query.callback
      results: _.filter scope.availableDistributor.fetch().concat(scope.availablePartner.fetch()), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name
        unsignedName.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) ->
      currentImport = Session.get('currentImport')
      distributor = Schema.distributors.findOne(currentImport.distributor) if currentImport.distributor
      partner = Schema.partners.findOne(currentImport.partner) if currentImport.partner
      callback(distributor ? partner ? 'skyReset')
    formatSelection: formatDistributorSearch
    formatResult: formatDistributorSearch
    id: '_id'
    placeholder: 'CHỌN NHÀ PHÂN PHỐI'
  #    minimumResultsForSearch: -1
    changeAction: (e) -> updateImportAndProduct(e)
    reactiveValueGetter: ->
      currentImport = Session.get('currentImport')
      currentImport.distributor ? currentImport.partner ? 'skyReset' if currentImport

