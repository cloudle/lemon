lemon.defineWidget Template.customerManagementSaleDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("customerManagementCurrentCustomer").customSaleDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]

  receivableClass: -> if @debtBalanceChange >= 0 then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'

  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  showDeleteSales: ->
    lastSaleId = Session.get("customerManagementCurrentCustomer")?.lastSales
    if @_id is lastSaleId and @creator is Session.get('myProfile').user
      new Date(@version.createdAt.getFullYear(), @version.createdAt.getMonth(), @version.createdAt.getDate() + 1, @version.createdAt.getHours(), @version.createdAt.getMinutes(), @version.createdAt.getSeconds()) > new Date()

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find {sale: saleId}, {sort: {'version.createdAt': 1}}

  latestPaids: -> Schema.transactions.find({latestSale: @_id})

  events:
    "click .deleteSales": (event, template) ->
      console.log 'delete'
      currentSales = @
      if Schema.returns.find({timeLineSales: currentSales._id}).count() is 0
        customerIncOption =
          saleDebt: -currentSales.debtBalanceChange
          saleTotalCash: -currentSales.debtBalanceChange

        transactions = Schema.transactions.find({latestSale: currentSales._id})
        for transaction in transactions
          customerIncOption.salePaid = -transaction.debtBalanceChange
          customerIncOption.saleDebt = transaction.debtBalanceChange
          Schema.transactions.remove transaction._id

        Schema.sales.remove currentSales._id
        Schema.saleDetails.find({sale: currentSales._id}).forEach(
          (detail)->
            Schema.saleDetails.remove detail._id

            Schema.productDetails.update detail.productDetail, $inc: {
              unitQuality      : detail.unitQuality
              availableQuality : detail.quality
              inStockQuality   : detail.quality
            }

            Schema.products.update detail.product, $inc: {
              availableQuality: detail.quality
              inStockQuality  : detail.quality
            }
        )

        lastSale = Schema.sales.findOne({buyer: currentSales.buyer}, {sort: {'version.createdAt': -1}})
        if lastSale
          Schema.customers.update currentSales.buyer, $set: {lastSales: lastSale._id}, $inc: customerIncOption
        else
          Schema.customers.update currentSales.buyer, $inc: customerIncOption

        Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
        Meteor.call 'reCalculateMetroSummary'
      else
