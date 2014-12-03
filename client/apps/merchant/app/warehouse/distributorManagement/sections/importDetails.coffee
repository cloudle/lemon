lemon.defineWidget Template.distributorManagementImportDetails,
  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt
  skulls: -> Schema.products.findOne(@product)?.skulls[0]

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.importDetails.find {import: importId}, {sort: {'version.createdAt': 1}}

  latestPaids: -> Schema.transactions.find({latestImport: @_id})