Apps.Merchant.importReviewInit.push (scope) ->
  scope.gridOptions =
    itemTemplate: 'importReviewThumbnail'
    reactiveSourceGetter: -> scope.importReviews
    wrapperClasses: 'detail-grid row'
