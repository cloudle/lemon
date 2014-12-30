lemon.defineWidget Template.customerManagementSaleDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("customerManagementCurrentCustomer").customSaleDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]
  receivableClass: -> if @debtBalanceChange >= 0 then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'
  isShowDeleteTransaction: -> new Date(@debtDate.getFullYear(), @debtDate.getMonth(), @debtDate.getDate() + 1, @debtDate.getHours(), @debtDate.getMinutes(), @debtDate.getSeconds()) > new Date()
  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  unitSaleQuality: -> Math.round(@quality/@conversionQuality*100)/100
  showDeleteSales: ->
    if @creator is Session.get('myProfile').user and @paymentsDelivery is 0
      new Date(@version.createdAt.getFullYear(), @version.createdAt.getMonth(), @version.createdAt.getDate() + 1, @version.createdAt.getHours(), @version.createdAt.getMinutes(), @version.createdAt.getSeconds()) > new Date()

  saleDetailCount: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find({sale: saleId}, {sort: {'version.createdAt': 1}}).count() > 0

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find {sale: saleId}, {sort: {'version.createdAt': 1}}



  latestPaids: -> Schema.transactions.find({latestSale: @_id}, {sort: {debtDate: 1}})
  returns: -> Schema.returns.find({timeLineSales: @_id})
  returnDetails: -> Schema.returnDetails.find({return: @_id})

  events:
    "click .deleteSales": (event, template) ->
      Meteor.call 'customerManagementDeleteSale', @_id
      Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
      Meteor.call 'reCalculateMetroSummary'

    "click .deleteTransaction": (event, template) ->
      Meteor.call 'customerManagementDeleteTransaction', @_id
      Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
      Meteor.call 'reCalculateMetroSummary'