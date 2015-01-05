Apps.Merchant.importInit.push (scope) ->
  logics.import.importDetailOptions =
    itemTemplate: 'importProductThumbnail'
    reactiveSourceGetter: -> logics.import.currentImportDetails
    wrapperClasses: 'detail-grid row'