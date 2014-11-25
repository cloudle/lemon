lemon.defineWidget Template.customerManagementSaleDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    console.log saleId
    Schema.saleDetails.find({sale: saleId})