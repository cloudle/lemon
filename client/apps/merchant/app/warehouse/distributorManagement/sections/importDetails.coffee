lemon.defineWidget Template.distributorManagementImportDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.importDetails.find({import: importId})