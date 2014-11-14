Apps.Merchant.staffManagerInit.push (scope) ->
  scope.gridOptions =
    itemTemplate: 'roleDetailThumbnail'
    reactiveSourceGetter: -> Schema.userProfiles.find({})
    wrapperClasses: 'detail-grid row'