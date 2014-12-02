updateCustomerDenyDelete = (id)-> Schema.customers.update id, $set: {allowDelete: false}
updateCustomSaleDetailDenyDelete = (latestCustomSaleId)->
  latestCustomSaleDetails = Schema.customSaleDetails.find({customSale: latestCustomSaleId})
  if latestCustomSaleDetails.count() > 0
    for customSaleDetail in latestCustomSaleDetails.fetch()
      Schema.customSaleDetails.update customSaleDetail._id, $set:{allowDelete: false}
    Schema.customSales.update latestCustomSaleId, $set:{allowDelete: false}

updateLatestTransactionDenyDelete = (ownerId)->
  latestTransactions = Schema.transactions.find({owner: ownerId, allowDelete: true}).fetch()
  (Schema.transactions.update transaction._id, $set:{allowDelete: false}) for transaction in latestTransactions

update=(buyerId)->
  if latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
    for customSaleDetail in Schema.customSaleDetails.find({customSale: latestCustomSale._id}).fetch()
      Schema.customSaleDetails.update customSaleDetail._id, $set:{allowDelete: true}

    if latestTransaction = Schema.transactions.findOne({latestSale: latestCustomSale._id}, {sort: {debtDate: -1}})
      Schema.transactions.update latestTransaction._id, $set:{allowDelete: true}
    else
      Schema.customSales.update latestCustomSale._id, $set:{allowDelete: true}


calculateCustomSale = (customSaleId, customSaleDetailFinalPrice)->
  if Schema.customSaleDetails.findOne({customSale: customSaleId}) is undefined
    setOption = {allowDelete: true}
  else
    setOption = {}

  incCustomSaleOption = {
    totalCash        : customSaleDetailFinalPrice
    debtBalanceChange: customSaleDetailFinalPrice
    latestDebtBalance: customSaleDetailFinalPrice
  }
  Schema.customSales.update customSaleId, $set: setOption, $inc: incCustomSaleOption


calculateCustomer = (customerId, customSaleDetailFinalPrice)->
  customer = Schema.customers.findOne(customSale.buyer)
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
          latestCustomSale  = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
          customSaleDetails = Schema.customSaleDetails.find({customSale: customSale._id}).fetch()

          if customSale._id is latestCustomSale._id
            if customSaleDetails.length > 0
              incCustomerOption = {
                customSaleDebt     : -customSale.debtBalanceChange
                customSaleTotalCash: -customSale.debtBalanceChange
              }
              Schema.customers.update customer._id, $inc: incCustomerOption
              Schema.customSaleDetails.remove customSaleDetail._id for customSaleDetail in customSaleDetails
            Schema.customSales.remove customSale._id

            transactions = Schema.transactions.find({latestSale: customSale._id}).fetch()
            if transactions.length > 0
              incCustomerOption = {customSaleDebt: 0, customSalePaid: 0}
              for transaction in transactions
                incCustomerOption.customSaleDebt += transaction.debtBalanceChange
                incCustomerOption.customSalePaid -= transaction.debtBalanceChange
                Schema.transactions.remove transaction._id
              Schema.customers.update customer._id, $inc: incCustomerOption
          else
            Schema.customSales.remove customSale._id if customSaleDetails.length is 0

          if latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
            for customSaleDetail in Schema.customSaleDetails.find({customSale: latestCustomSale._id}).fetch()
              Schema.customSaleDetails.update customSaleDetail._id, $set:{allowDelete: true}

            if latestTransaction = Schema.transactions.findOne({latestSale: latestCustomSale._id}, {sort: {debtDate: -1}})
              Schema.transactions.update latestTransaction._id, $set:{allowDelete: true}
            else
              Schema.customSales.update latestCustomSale._id, $set:{allowDelete: true}

  updateCustomSaleByCreateCustomSaleDetail: (customSaleDetail)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customSale = Schema.customSales.findOne({_id: customSaleDetail.customSale, parentMerchant: profile.parentMerchant})
      latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})

      if customSale._id is latestCustomSale._id
        customer = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
        if customer.customSaleModeEnabled is true and Schema.customSaleDetails.insert customSaleDetail
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