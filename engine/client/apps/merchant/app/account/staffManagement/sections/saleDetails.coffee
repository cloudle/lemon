lemon.defineWidget Template.staffManagementSaleDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("staffManagementCurrentStaff").customSaleDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]

  receivableClass: -> if @debtBalanceChange >= 0 then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find {sale: saleId}, {sort: {'version.createdAt': 1}}

  latestPaids: -> Schema.transactions.find({latestSale: @_id})