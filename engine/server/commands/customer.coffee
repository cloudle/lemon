Meteor.methods
  calculateCustomer: (id)->
    if !mySession = Schema.userSessions.findOne({user: Meteor.userId()}) then throw 'Không tìm thấy mySession'
    if !id then id = mySession.currentCustomerManagementSelection
    if customer = Schema.customers.findOne(id)
      customerOption =
        customSalePaid      : 0
        customSaleDebt      : 0
        customSaleTotalCash : 0
        salePaid            : 0
        saleDebt            : 0
        saleTotalCash       : 0

      tempBeforeDebtBalance = 0
      Schema.customSales.find({buyer: customer._id}, {sort: {'version.createdAt': 1}}).forEach(
        (customSale) ->
          customerOption.customSaleDebt      += customSale.debtBalanceChange
          customerOption.customSaleTotalCash += customSale.debtBalanceChange

          Schema.customSales.update customSale._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + customSale.debtBalanceChange
          }
          tempBeforeDebtBalance += customSale.debtBalanceChange

          Schema.transactions.find({latestSale: customSale._id}).forEach(
            (transaction) ->
              if transaction.debtBalanceChange > 0
                customerOption.customSalePaid += transaction.debtBalanceChange
                customerOption.customSaleDebt -= transaction.debtBalanceChange
              else
                customerOption.customSaleDebt      -= transaction.debtBalanceChange
                customerOption.customSaleTotalCash -= transaction.debtBalanceChange

              Schema.transactions.update transaction._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - transaction.debtBalanceChange
              }
              tempBeforeDebtBalance -= transaction.debtBalanceChange
          )
      )

      tempBeforeDebtBalance = 0
      Schema.sales.find({buyer: customer._id}, {sort: {'version.createdAt': 1}}).forEach(
        (currentSale) ->
          customerOption.saleDebt      += currentSale.debtBalanceChange
          customerOption.saleTotalCash += currentSale.debtBalanceChange

          Schema.sales.update currentSale._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + currentSale.debtBalanceChange
          }
          tempBeforeDebtBalance += currentSale.debtBalanceChange

          transactions = Schema.transactions.find({latestSale: currentSale._id}).fetch()
          returns      = Schema.returns.find({timeLineSales: currentSale._id}).fetch()
          dependsData = _.sortBy transactions.concat(returns), (item) -> item.version.createdAt

          for data in dependsData
            if data.latestSale
              if data.debtBalanceChange > 0
                customerOption.salePaid += data.debtBalanceChange
                customerOption.saleDebt -= data.debtBalanceChange
              else
                customerOption.saleDebt      -= data.debtBalanceChange
                customerOption.saleTotalCash -= data.debtBalanceChange

              Schema.transactions.update data._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - data.debtBalanceChange
              }
              tempBeforeDebtBalance -= data.debtBalanceChange
            else
              customerOption.saleDebt      -= data.debtBalanceChange
              customerOption.saleTotalCash -= data.debtBalanceChange

              Schema.returns.update data._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - data.debtBalanceChange
              }
              tempBeforeDebtBalance -= data.debtBalanceChange
      )
      Schema.customers.update customer._id, $set: customerOption

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

      saleDetails = Schema.saleDetails.find({sale: currentSales._id}).fetch()
      if saleDetails.length > 0
        (throw 'Phiếu bán đã trả hàng không thể xóa.' if saleDetail.returnQuality > 0) for saleDetail in saleDetails

      if Schema.saleDetails.find({sale: currentSales._id}).count() > 0
        customerIncOption =
          salePaid: 0
          saleDebt: -currentSales.debtBalanceChange
          saleTotalCash: -currentSales.debtBalanceChange
      else
        customerIncOption =
          salePaid: 0
          saleDebt: 0
          saleTotalCash: 0

      Schema.transactions.find({latestSale: currentSales._id}).forEach(
        (transaction) ->
          if transaction.debtBalanceChange > 0
            customerIncOption.salePaid += -transaction.debtBalanceChange
            customerIncOption.saleDebt += transaction.debtBalanceChange
          else
            customerIncOption.saleDebt += transaction.debtBalanceChange
            customerIncOption.saleTotalCash += transaction.debtBalanceChange

          Schema.transactions.remove transaction._id
      )
      MetroSummary.updateMyMetroSummaryBy(['deleteSale'], currentSales._id)
      Schema.sales.remove currentSales._id
      Schema.saleDetails.find({sale: currentSales._id}).forEach(
        (detail)->
          if branchProduct = Schema.branchProductSummaries.findOne(detail.branchProduct)
            if branchProduct.basicDetailModeEnabled is false
              updateOption = {availableQuality: detail.quality, inStockQuality: detail.quality}
              Schema.productDetails.update detail.productDetail, $inc: updateOption

              updateOption.salesQuality = -detail.quality
              Schema.products.update detail.product, $inc: updateOption
              Schema.branchProductSummaries.update detail.branchProduct, $inc: updateOption
            else
              Schema.products.update detail.product, $inc: {salesQuality: -detail.quality}
              Schema.branchProductSummaries.update detail.branchProduct, $inc: {salesQuality: -detail.quality}

          Schema.saleDetails.remove detail._id
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
      MetroSummary.updateMyMetroSummaryByProfitability()
      Meteor.call 'updateMetroSummaryBy', 'deleteSale', currentSales._id, currentSales.merchant

    catch error
      throw new Meteor.Error('deleteTransaction', error)

  customerManagementDeleteTransaction: (transactionId)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()}); if !profile then throw 'Không tìm thấy profile'
      currentTransaction = Schema.transactions.findOne(transactionId); if !currentTransaction then throw 'Không tìm thấy Transaction'
      validDateTransaction = new Date(currentTransaction.debtDate.getFullYear(),
          currentTransaction.debtDate.getMonth(),
          currentTransaction.debtDate.getDate() + 1,
          currentTransaction.debtDate.getHours(),
          currentTransaction.debtDate.getMinutes(),
          currentTransaction.debtDate.getSeconds()
        ); if validDateTransaction < new Date() then 'Transaction vượt quá 24h.'
      currentSale = Schema.sales.findOne(currentTransaction.latestSale); if !currentSale then throw 'Không tìm thấy Sale'

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

      if currentSale.debtBalanceChange is 0 and Schema.transactions.find(latestSale: currentSale._id).count() is 0
        Schema.sales.remove currentSale._id

      tempBeforeDebtBalance = currentSale.beforeDebtBalance
      Schema.sales.find({buyer: currentSale.buyer, 'version.createdAt': {$gte: currentSale.version.createdAt} }
      , {sort: {'version.createdAt': 1}}).forEach(
        (sale) ->
          transactions = Schema.transactions.find({latestSale: sale._id}).fetch()
          returns = Schema.returns.find({timeLineSales: sale._id}).fetch()
          dependsData = _.sortBy transactions.concat(returns), (item) -> item.version.createdAt

          #cập nhật phiếu bán hàng
          Schema.sales.update sale._id, $set:{
            beforeDebtBalance: tempBeforeDebtBalance
            latestDebtBalance: tempBeforeDebtBalance + sale.debtBalanceChange
          }
          tempBeforeDebtBalance += sale.debtBalanceChange

          for data in dependsData
            if data.latestSale
              #cập nhật phiếu công nợ
              Schema.transactions.update data._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - data.debtBalanceChange
              }
              tempBeforeDebtBalance -= data.debtBalanceChange
            else
              #cập nhật phiếu trả hàng
              Schema.returns.update data._id, $set:{
                beforeDebtBalance: tempBeforeDebtBalance
                latestDebtBalance: tempBeforeDebtBalance - data.debtBalanceChange
              }
              tempBeforeDebtBalance -= data.debtBalanceChange
        )
      Schema.customers.update currentTransaction.owner, $inc: customerIncOption
    catch error
      throw new Meteor.Error('deleteTransaction', error)
