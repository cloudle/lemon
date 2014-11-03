Apps.Merchant.exportAndImportManagerInit.push (scope) ->
  logics.exportAndImportManager.gridOptions =
    itemTemplate: 'exportAndImportManagerThumbnail'
    reactiveSourceGetter: -> logics.exportAndImportManager.availableBills
    wrapperClasses: 'detail-grid row'