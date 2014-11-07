lemon.defineApp Template.importReview,
  rendered: ->
  events:
    "click .thumbnails": (event, template) ->
      Meteor.subscribe('importDetailInWarehouse', @_id)
      Session.set('currentImportReview', @)
      $(template.find '#importReviewDetail').modal()



