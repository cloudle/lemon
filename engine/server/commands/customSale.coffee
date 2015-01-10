updateCustomerDenyDelete = (id)-> Schema.customers.update id, $set: {allowDelete: false}
updateCustomSaleDetailDenyDelete = (customSaleId)->
  latestCustomSaleDetails = Schema.customSaleDetails.find({customSale: customSaleId})
  if latestCustomSaleDetails.count() > 0
    for customSaleDetail in latestCustomSaleDetails.fetch()
      Schema.customSaleDetails.update customSaleDetail._id, $set:{allowDelete: false}
    Schema.customSales.update customSaleId, $set:{allowDelete: false}

updateCustomSaleDetailAllowDeleteBy = (customSaleId)->
  for customSaleDetail in Schema.customSaleDetails.find({customSale: customSaleId}).fetch()
    Schema.customSaleDetails.update customSaleDetail._id, $set:{allowDelete: true}

updateTransactionOrCustomSalesAllowDeleteBy = (customSaleId)->
  if latestTransaction = Schema.transactions.findOne({latestSale: customSaleId}, {sort: {debtDate: -1}})
    Schema.transactions.update latestTransaction._id, $set:{allowDelete: true}
  else
    Schema.customSales.update customSaleId, $set:{allowDelete: true}

updateLatestTransactionDenyDelete = (ownerId)->
  latestTransactions = Schema.transactions.find({owner: ownerId, allowDelete: true}).fetch()
  (Schema.transactions.update transaction._id, $set:{allowDelete: false}) for transaction in latestTransactions

calculateCustomSale = (customSaleId, customSaleDetailFinalPrice)->
  if Schema.transactions.findOne({latestSale: customSaleId})
    setOption = {allowDelete: false}
  else
    setOption = {allowDelete: true}

  incCustomSaleOption = {
    totalCash        : customSaleDetailFinalPrice
    debtBalanceChange: customSaleDetailFinalPrice
    latestDebtBalance: customSaleDetailFinalPrice
  }
  Schema.customSales.update customSaleId, $set: setOption, $inc: incCustomSaleOption

calculateCustomer = (customerId, customSaleDetailFinalPrice)->
  customer = Schema.customers.findOne(customerId)
  incCustomerOption = {
    customSaleDebt     : customSaleDetailFinalPrice
    customSaleTotalCash: customSaleDetailFinalPrice
  }
  Schema.customers.update customer._id, $inc: incCustomerOption

calculateDebtBalanceTransactionOf = (customSaleId)->
  beforeDebtBalance = Schema.customSales.findOne(customSaleId).latestDebtBalance
  for transaction in Schema.transactions.find({latestSale: customSaleId}).fetch()
    latestDebtBalance = beforeDebtBalance - transaction.debtBalanceChange
    Schema.transactions.update transaction._id, $set: {beforeDebtBalance: beforeDebtBalance, latestDebtBalance: latestDebtBalance}
    beforeDebtBalance = latestDebtBalance

checkAndRemoveCustomSales = (customSaleId, latestCustomSaleId, customerId, debtBalanceChange)->
  customSaleDetails = Schema.customSaleDetails.find({customSale: customSaleId})
  if customSaleId is latestCustomSaleId
    if customSaleDetails.count() > 0
      Schema.customers.update customerId, $inc:{customSaleDebt: -debtBalanceChange, customSaleTotalCash: -debtBalanceChange}
      Schema.customSaleDetails.remove customSaleDetail._id for customSaleDetail in customSaleDetails.fetch()
    Schema.customSales.remove customSaleId

    transactions = Schema.transactions.find({latestSale: customSaleId})
    if transactions.count() > 0
      incCustomerOption = {customSaleDebt: 0, customSalePaid: 0}
      for transaction in transactions.fetch()
        incCustomerOption.customSaleDebt += transaction.debtBalanceChange
        incCustomerOption.customSalePaid -= transaction.debtBalanceChange
        Schema.transactions.remove transaction._id
      Schema.customers.update customerId, $inc: incCustomerOption
  else
    Schema.customSales.remove customSaleId if customSaleDetails.count() is 0


Meteor.methods
  createCustomSale: (customSale)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
      customer = Schema.customers.findOne({_id:customSale.buyer, parentMerchant:profile.parentMerchant})
      if customer.customSaleModeEnabled is true
        if latestCustomSale
          if customSale.debtDate >= latestCustomSale.debtDate
            if Schema.customSales.insert customSale
              updateCustomerDenyDelete(customer._id)
              updateCustomSaleDetailDenyDelete(latestCustomSale._id)
              updateLatestTransactionDenyDelete(customer._id)
        else
          updateCustomerDenyDelete(customer._id) if Schema.customSales.insert customSale

  deleteCustomSale: (customSaleId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customSale = Schema.customSales.findOne({_id: customSaleId, parentMerchant: profile.parentMerchant})
        customer = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
        if customer.customSaleModeEnabled is true
          latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
          checkAndRemoveCustomSales(customSale._id, latestCustomSale._id, customer._id, customSale.debtBalanceChange)

          if latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
            updateCustomSaleDetailAllowDeleteBy(latestCustomSale._id)
            updateTransactionOrCustomSalesAllowDeleteBy(latestCustomSale._id)
          else
            customerOption= {customSaleDebt: 0, customSalePaid: 0, customSaleTotalCash: 0}
            if !Schema.sales.findOne({buyer: customer._id})
              customerOption.allowDelete   = true
              customerOption.saleDebt      = 0
              customerOption.salePaid      = 0
              customerOption.saleTotalCash = 0
            Schema.customers.update customer._id, $set: customerOption


  updateCustomSaleByCreateCustomSaleDetail: (customSaleDetail)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customSale = Schema.customSales.findOne({_id: customSaleDetail.customSale, parentMerchant: profile.parentMerchant})
      latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})

      if customSale._id is latestCustomSale._id
        customer = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
        if customer.customSaleModeEnabled is true and Schema.customSaleDetails.insert customSaleDetail
          console.log customSale
          calculateCustomSale(customSale._id, customSaleDetail.finalPrice)
          calculateCustomer(customSale.buyer, customSaleDetail.finalPrice)
          calculateDebtBalanceTransactionOf(customSale._id)


  updateCustomSaleByDeleteCustomSaleDetail: (customSaleDetailId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customSaleDetail = Schema.customSaleDetails.findOne({_id: customSaleDetailId, parentMerchant: profile.parentMerchant})
        customSale = Schema.customSales.findOne({_id: customSaleDetail.customSale, parentMerchant: profile.parentMerchant})
        latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})

        if customSale._id is latestCustomSale._id
          customer = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
          if customer.customSaleModeEnabled is true
            Schema.customSaleDetails.remove customSaleDetail._id

            calculateCustomSale(customSale._id, -customSaleDetail.finalPrice)
            calculateCustomer(customSale.buyer, -customSaleDetail.finalPrice)
            calculateDebtBalanceTransactionOf(customSale._id)


  calculateCustomSaleByCustomer: (customerId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customer = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
        customerOption = {
          customSaleDebt     : 0
          customSalePaid     : 0
          customSaleTotalCash: 0
        }
        allCustomSale = Schema.customSales.find({buyer: customer._id}, {sort: {'version.createdAt': 1}})
        allCustomSale.forEach(
          (customSale)->
            customSaleOption = {
              beforeDebtBalance: customerOption.customSaleDebt
              latestDebtBalance: customerOption.customSaleDebt + customSale.debtBalanceChange
            }
            Schema.customSales.update customSale._id, $set: customSaleOption

            customerOption.customSaleDebt      += customSale.debtBalanceChange
            customerOption.customSaleTotalCash += customSale.debtBalanceChange

            Schema.transactions.find({owner: customer._id, latestSale: customSale._id, group: "customSale"}, {sort: {debtDate: 1}}).forEach(
              (transaction)->
                transactionOption = {
                  beforeDebtBalance: customerOption.customSaleDebt
                  latestDebtBalance: customerOption.customSaleDebt - transaction.debtBalanceChange
                }
                Schema.transactions.update transaction._id, $set: transactionOption

                customerOption.customSaleDebt = transactionOption.latestDebtBalance
                if transaction.debtBalanceChange > 0
                  customerOption.customSalePaid += transaction.debtBalanceChange
                else
                  customerOption.customSaleTotalCash += -transaction.debtBalanceChange
            )
        )
        Schema.customers.update customer._id, $set: customerOption

  calculateSaleByCustomer: (customerId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customer = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
        customerOption = {
          saleDebt: 0
          salePaid: 0
          saleTotalCash: 0
        }

        allSale = Schema.sales.find({buyer: customer._id}, {sort: {'version.createdAt': 1}})
        allSale.forEach(
          (sale)->
            saleOption = {
              beforeDebtBalance: customerOption.saleDebt
              debtBalanceChange: sale.finalPrice
              latestDebtBalance: customerOption.saleDebt + sale.finalPrice
            }
            Schema.sales.update sale._id, $set: saleOption

            customerOption.saleDebt      += sale.finalPrice
            customerOption.saleTotalCash += sale.finalPrice

            Schema.transactions.find({owner: customer._id, latestSale: sale._id, group: "sales"}, {sort: {debtDate: 1}}).forEach(
              (transaction)->
                transactionOption = {
                  beforeDebtBalance: customerOption.saleDebt
                  latestDebtBalance: customerOption.saleDebt - transaction.debtBalanceChange
                }
                Schema.transactions.update transaction._id, $set: transactionOption

                customerOption.saleDebt = transactionOption.latestDebtBalance
                if transaction.debtBalanceChange > 0
                  customerOption.salePaid += transaction.debtBalanceChange
                else
                  customerOption.saleTotalCash += -transaction.debtBalanceChange
            )
        )
        Schema.customers.update customer._id, $set: customerOption

