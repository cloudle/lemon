lemon.defineWidget Template.customerManagementSaleDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find({sale: saleId})

  latestPaids: -> Schema.transactions.find({latestSale: @_id})