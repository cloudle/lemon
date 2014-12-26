lemon.defineWidget Template.customerManagementSaleDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("customerManagementCurrentCustomer").customSaleDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]

  receivableClass: -> if @debtBalanceChange >= 0 then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'

  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  showDeleteSales: ->
    if @creator is Session.get('myProfile').user and @paymentsDelivery is 0
      new Date(@version.createdAt.getFullYear(), @version.createdAt.getMonth(), @version.createdAt.getDate() + 1, @version.createdAt.getHours(), @version.createdAt.getMinutes(), @version.createdAt.getSeconds()) > new Date()

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find {sale: saleId}, {sort: {'version.createdAt': 1}}

  latestPaids: -> Schema.transactions.find({latestSale: @_id})
  returns: -> Schema.returns.find({timeLineSales: @_id})
  returnDetails: -> Schema.returnDetails.find({return: @_id})

  events:
    "click .deleteSales": (event, template) ->
      #TODO: chuyển sang Server
      try
        currentSales = @
        throw 'Phiếu bán đã trả hàng không thể xóa.' if Schema.returns.find({timeLineSales: currentSales._id}).count() > 0
        throw 'Không thể xóa khi có phiếu giao hàng.' if @paymentsDelivery is 1
        customerIncOption =
          salePaid: 0
          saleDebt: -currentSales.debtBalanceChange
          saleTotalCash: -currentSales.debtBalanceChange

        Schema.transactions.find({latestSale: currentSales._id}).forEach(
          (transaction) ->
            customerIncOption.salePaid += -transaction.debtBalanceChange
            customerIncOption.saleDebt += -(currentSales.debtBalanceChange - transaction.debtBalanceChange)
            Schema.transactions.remove transaction._id
        )

        Schema.sales.remove currentSales._id
        Schema.saleDetails.find({sale: currentSales._id}).forEach(
          (detail)->
            Schema.saleDetails.remove detail._id

            product = Schema.products.findOne(detail.product)
            if product.basicDetailModeEnabled is false
              Schema.productDetails.update detail.productDetail, $inc: {
                availableQuality : detail.quality
                inStockQuality   : detail.quality
              }

              Schema.products.update detail.product, $inc: {
                availableQuality: detail.quality
                inStockQuality  : detail.quality
              }
        )

        tempBeforeDebtBalance = currentSales.beforeDebtBalance
        Schema.sales.find({buyer: currentSales.buyer, 'version.createdAt': {$gt: currentSales.version.createdAt} }
        , {sort: {'version.createdAt': 1}}).forEach(
          (sale) ->
            Schema.sales.update sale._id, $set:{
              beforeDebtBalance: tempBeforeDebtBalance
              latestDebtBalance: tempBeforeDebtBalance + sale.debtBalanceChange
            }
            tempBeforeDebtBalance += sale.debtBalanceChange
            Schema.transactions.find({latestSale: sale._id}).forEach(
              (transaction) ->
                Schema.transactions.update transaction._id, $set:{
                  beforeDebtBalance: tempBeforeDebtBalance
                  latestDebtBalance: tempBeforeDebtBalance - transaction.debtBalanceChange
                }
                tempBeforeDebtBalance -= transaction.debtBalanceChange
            )
        )

        lastSale = Schema.sales.findOne({buyer: currentSales.buyer}, {sort: {'version.createdAt': -1}})
        if lastSale
          Schema.customers.update currentSales.buyer, $set: {lastSales: lastSale._id}, $inc: customerIncOption
        else
          Schema.customers.update currentSales.buyer, $inc: customerIncOption

        Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
        Meteor.call 'reCalculateMetroSummary'
      catch error
        console.log error

    "click .deleteTransaction": (event, template) ->
      #TODO: chuyển sang Server
      try
        currentTransaction = @
        currentSales = Schema.sales.findOne(currentTransaction.latestSale)
        throw 'Không tìm thấy Sales.' if !currentSales

        customerIncOption =
          salePaid: 0
          saleDebt: 0
          saleTotalCash: 0

        if currentTransaction.debtBalanceChange > 0
          customerIncOption.salePaid = -currentTransaction.debtBalanceChange
          customerIncOption.saleDebt = currentTransaction.debtBalanceChange
        else
          customerIncOption.saleDebt = currentTransaction.debtBalanceChange
          customerIncOption.saleTotalCash = currentTransaction.debtBalanceChange
        Schema.transactions.remove currentTransaction._id

        tempBeforeDebtBalance = currentSales.beforeDebtBalance
        Schema.sales.find({buyer: currentSales.buyer, 'version.createdAt': {$gt: currentSales.version.createdAt} }
        , {sort: {'version.createdAt': 1}}).forEach(
          (sale) ->
            Schema.sales.update sale._id, $set:{
              beforeDebtBalance: tempBeforeDebtBalance
              latestDebtBalance: tempBeforeDebtBalance + sale.debtBalanceChange
            }
            tempBeforeDebtBalance += sale.debtBalanceChange
            Schema.transactions.find({latestSale: sale._id}).forEach(
              (transaction) ->
                Schema.transactions.update transaction._id, $set:{
                  beforeDebtBalance: tempBeforeDebtBalance
                  latestDebtBalance: tempBeforeDebtBalance - transaction.debtBalanceChange
                }
                tempBeforeDebtBalance -= transaction.debtBalanceChange
            )
        )
        Schema.customers.update currentTransaction.owner, $inc: customerIncOption
        Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
        Meteor.call 'reCalculateMetroSummary'
      catch error
        console.log error
