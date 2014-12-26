Meteor.methods
  updateCustomerDebitAndPurchase: ->
    for customer in Schema.customers.find({}).fetch()
      Schema.customers.update(customer._id, $set:{totalPurchases: 0,  totalDebit: 0})
    for transaction in Schema.transactions.find({group: {$in:['sale', 'customer']}, receivable: true }).fetch()
      Schema.customers.update transaction.owner, $inc:{totalPurchases: transaction.totalCash,  totalDebit: transaction.debitCash}

  customerManagementDeleteSale: (saleId)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()}); if !profile then throw 'Không tìm thấy profile'
      currentSales = Schema.sales.findOne(saleId); if !currentSales then throw 'Không tìm thấy profile'
      throw 'Phiếu bán đã trả hàng không thể xóa.' if Schema.returns.find({timeLineSales: currentSales._id}).count() > 0
      throw 'Không thể xóa khi có phiếu giao hàng.' if currentSales.paymentsDelivery is 1

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

      Schema.customers.update currentSales.buyer, $inc: customerIncOption

    catch error
      throw new Meteor.Error('deleteTransaction', error)

  customerManagementDeleteTransaction: (transactionId)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()}); if !profile then throw 'Không tìm thấy profile'
      currentTransaction = Schema.transactions.findOne(transactionId); if !currentTransaction then throw 'Không tìm thấy Transaction'
      currentSales = Schema.sales.findOne(currentTransaction.latestSale); if !currentSales then throw 'Không tìm thấy Sale'

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
      Schema.sales.find({buyer: currentSales.buyer, 'version.createdAt': {$gte: currentSales.version.createdAt} }
      , {sort: {'version.createdAt': 1}}).forEach(
        (sale) ->
          #cập nhật phiếu bán hàng
          Schema.sales.update sale._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + sale.debtBalanceChange
          }
          tempBeforeDebtBalance += sale.debtBalanceChange

          #cập nhật phiếu công nợ
          Schema.transactions.find({latestSale: sale._id}).forEach(
            (transaction) ->
              Schema.transactions.update transaction._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - transaction.debtBalanceChange
              }
              tempBeforeDebtBalance -= transaction.debtBalanceChange
          )

          #cập nhật phiếu trả hàng
          Schema.returns.find({timeLineSales: sale._id}).forEach(
            (currentReturn) ->
              Schema.returns.update currentReturn._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - currentReturn.debtBalanceChange
              }
              tempBeforeDebtBalance -= currentReturn.debtBalanceChange
          )
        )
      Schema.customers.update currentTransaction.owner, $inc: customerIncOption
    catch error
      throw new Meteor.Error('deleteTransaction', error)



#  updateImportAndImport: ->
#    Schema.imports.find({finish: true, submitted: true}).forEach((item)-> Schema.imports.update item._id, $set: {'version.createdAt': item.version.updateAt})
#    Schema.returns.find({status: 2}).forEach((item)-> Schema.returns.update item._id, $set: {'version.createdAt': item.version.updateAt})