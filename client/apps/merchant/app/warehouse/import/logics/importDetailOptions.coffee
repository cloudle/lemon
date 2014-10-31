Apps.Merchant.importInit.push (scope) ->
  logics.import.importDetailOptions =
    itemTemplate: 'importProductThumbnail'
    reactiveSourceGetter: -> logics.import.currentImportDetails.fetch()
    wrapperClasses: 'detail-grid row'