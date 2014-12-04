lemon.defineWidget Template.productManagementImportDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("productManagementCurrentProduct").customSaleDebt
  providerName: -> Schema.providers.findOne(@provider)?.name

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId, product: Session.get("productManagementCurrentProduct")._id}