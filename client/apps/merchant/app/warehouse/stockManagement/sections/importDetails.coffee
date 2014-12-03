lemon.defineWidget Template.stockManagementImportDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("stockManagementCurrentProduct").customSaleDebt
  providerName: -> Schema.providers.findOne(@provider)?.name

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId, product: Session.get("stockManagementCurrentProduct")._id}

  latestPaids: -> Schema.transactions.find({latestSale: @_id})