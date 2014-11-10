lemon.defineApp Template.inventoryReview,
  events:
    "click .thumbnails": (event, template) ->
      Apps.MerchantSubscriber.subscribe('productLostInInventory', @_id)
      Apps.MerchantSubscriber.subscribe('inventoryDetailInWarehouse', @_id)
      Session.set('currentInventoryReview', @)
      $(template.find '#inventoryReviewDetail').modal()



