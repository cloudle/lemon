Apps.Merchant.staffManagerInit.push (scope) ->
  logics.staffManager.gridOptions =
    itemTemplate: 'roleDetailThumbnail'
    reactiveSourceGetter: -> Schema.userProfiles.find({})
    wrapperClasses: 'detail-grid row'