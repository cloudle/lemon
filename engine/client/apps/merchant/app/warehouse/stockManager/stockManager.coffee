lemon.defineApp Template.stockManager,
  events:
    "click .thumbnails": (event, template) ->
      Meteor.subscribe('productDetails', @_id)
      Session.set('currentProduct', @)
      Session.set('updateProductPrice', false)
      $(template.find '#productEdit').modal()

