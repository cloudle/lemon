lemon.defineWidget Template.distributorManagementImportDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("customerManagementCurrentDistributor").customImportDebt

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.importDetails.find({import: importId})

  latestPaids: -> Schema.transactions.find({latestImport: @_id})