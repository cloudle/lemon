saleStatusIsExport = (sale)->
  if sale.status == sale.received == true and sale.submitted == sale.exported == sale.imported == false and (sale.paymentsDelivery == 0 || sale.paymentsDelivery == 1)
    true
  else
    false

saleStatusIsImport = (sale)->
  if sale.status == sale.received == sale.exported == true and sale.submitted == sale.imported == false and sale.paymentsDelivery == 1
    true
  else
    false

Schema.add 'metroSummaries', "MetroSummary", class MetroSummary
  @newByMerchant: (merchantId)->
    currentMerchant = Schema.merchants.findOne(merchantId)
    if currentMerchant
      merchant       = currentMerchant._id
      parentMerchant = currentMerchant.parent ? currentMerchant._id
      staffCount       = Schema.userProfiles.find({currentMerchant: merchant})
      staffCountAll    = Schema.userProfiles.find({parentMerchant: parentMerchant})
      customerCount    = Schema.customers.find({currentMerchant: merchant})
      customerCountAll = Schema.customers.find({parentMerchant: parentMerchant})
      merchantCount    = Schema.merchants.find({$or:[{_id: parentMerchant }, {parent: parentMerchant}]})
      warehouseCountAll= Schema.warehouses.find({$or:[{merchant: parentMerchant }, {parentMerchant: parentMerchant}]})
      warehouseCount   = Schema.warehouses.find({merchant: merchant })

      option =
        parentMerchant        : parentMerchant
        merchant              : merchant
        customerCountAll      : customerCountAll.count()
        customerCount         : customerCount.count()
        staffCountAll         : staffCountAll.count()
        staffCount            : staffCount.count()
        merchantCount         : merchantCount.count()
        warehouseCount        : warehouseCount.count()
        warehouseCountAll     : warehouseCountAll.count()

  updateMetroSummary: ->
    merchantCount    = Schema.merchants.find({$or:[{_id: @data.parentMerchant }, {parent: @data.parentMerchant}]})
    warehouseCountAll= Schema.warehouses.find({$or:[{merchant: @data.parentMerchant }, {parentMerchant: @data.parentMerchant}]})
    warehouseCount   = Schema.warehouses.find({merchant: @data.merchant})
    staffCount       = Schema.userProfiles.find({currentMerchant: @data.merchant})
    staffCountAll    = Schema.userProfiles.find({parentMerchant: @data.parentMerchant})
    customerCount    = Schema.customers.find({currentMerchant: @data.merchant})
    customerCountAll = Schema.customers.find({parentMerchant: @data.parentMerchant})

    products         = Schema.products.find({merchant: @data.merchant })
    importCount      = Schema.imports.find({finish: true, merchant: @data.merchant})
    saleCount        = Schema.sales.find({merchant: @data.merchant })
    deliveryCount    = Schema.deliveries.find({merchant: @data.merchant})
    inventoryCount   = Schema.inventories.find({success: true, merchant: @data.merchant})
    returnCount      = Schema.returns.find({merchant: @data.merchant, status: 2})
    transactionCount = Schema.transactions.find({merchant: @data.merchant})

    stockProductCount = 0; availableProductCount = 0
    for item in products.fetch()
      stockProductCount += item.inStockQuality if item.inStockQuality > 0
      availableProductCount += item.availableQuality

    inventoryProductCount = 0
    for inventory in inventoryCount.fetch()
      for detail in Schema.inventoryDetails.find({inventory: inventory._id}).fetch()
        inventoryProductCount+= detail.lostQuality

    saleProductCount = 0
    for item in saleCount.fetch()
      saleProductCount+= item.saleCount

    importProductCount = 0
    for imports in importCount.fetch()
      for detail in Schema.importDetails.find({import: imports._id}).fetch()
        importProductCount+= detail.importQuality

    deliveryProductCount = 0
    for delivery in deliveryCount.fetch()
      for detail in Schema.saleDetails.find({sale: delivery.sale}).fetch()
        deliveryProductCount += detail.quality

    returnProductCount = 0
    for returns in returnCount.fetch()
      for detail in Schema.returnDetails.find({return: returns._id}).fetch()
        returnProductCount += detail.returnQuality

    returnCash = 0
    for item in returnCount.fetch()
      returnCash += item.totalPrice

    saleDepositCash   = 0; saleDebitCash   = 0; saleRevenueCash = 0
    importDepositCash = 0; importDebitCash = 0; importRevenueCash = 0
    for item in transactionCount.fetch()
      if item.group is 'sale'
        saleDepositCash += item.depositCash
        saleDebitCash   += item.debitCash
        saleRevenueCash += item.totalCash
      if item.group is 'import'
        importDepositCash += item.depositCash
        importDebitCash   += item.debitCash
        importRevenueCash += item.totalCash

    option =
      customerCountAll      : customerCountAll.count()
      customerCount         : customerCount.count()
      staffCountAll         : staffCountAll.count()
      staffCount            : staffCount.count()
      merchantCount         : merchantCount.count()
      warehouseCount        : warehouseCount.count()
      warehouseCountAll     : warehouseCountAll.count()
      productCount          : products.count()
      stockProductCount     : stockProductCount
      availableProductCount : availableProductCount
      importCount           : importCount.count()
      importProductCount    : importProductCount
      saleCount             : saleCount.count()
      saleProductCount      : saleProductCount
      deliveryCount         : deliveryCount.count()
      deliveryProductCount  : deliveryProductCount
      inventoryCount        : inventoryCount.count()
      inventoryProductCount : inventoryProductCount
      returnCount           : returnCount.count()
      returnProductCount    : returnProductCount

      returnCash            : returnCash
      saleDepositCash       : saleDepositCash
      saleDebitCash         : saleDebitCash
      saleRevenueCash       : saleRevenueCash
      importDepositCash     : importDepositCash
      importDebitCash       : importDebitCash
      importRevenueCash     : importRevenueCash

    Schema.metroSummaries.update @id, $set: option

  @updateMetroSummaryByStaff: (staffId)->
    profile = Schema.userProfiles.findOne({user: staffId})
    if profile
      for item in Schema.metroSummaries.find({parentMerchant: profile.parentMerchant}).fetch()
        option = {staffCountAll: 1}
        option.staffCount = 1 if item.merchant is profile.currentMerchant
        Schema.metroSummaries.update item._id, $inc: option

  @updateMetroSummaryByStaffDestroy: (userId)->
    profile = Schema.userProfiles.findOne({user: userId})
    if profile
      for item in Schema.metroSummaries.find({parentMerchant: profile.parentMerchant}).fetch()
        option = {staffCountAll: -1}
        option.staffCount = -1 if item.merchant is profile.currentMerchant
        Schema.metroSummaries.update item._id, $inc: option

  @updateMetroSummaryBySale: (saleId)->
    if sale = Schema.sales.findOne({_id: saleId, received: true})
      setOption = {}
      incOption =
        saleCount             : 1
        saleProductCount      : sale.saleCount
        availableProductCount : -sale.saleCount
        saleDepositCash       : sale.deposit
        saleDebitCash         : sale.debit
        saleDiscountCash      : sale.totalPrice - sale.finalPrice
        saleRevenueCash       : sale.finalPrice
        stockProductCount     : -sale.saleCount if sale.success == true

        depositDay    : sale.deposit
        debitDay      : sale.debit
        discountDay   : sale.totalPrice - sale.finalPrice
        revenueDay    : sale.finalPrice
        cogsDay       : 0

      if sale.paymentsDelivery is 1
        incOption.deliveryCount        = 1
        incOption.deliveryProductCount = sale.saleCount

      metroSummary = Schema.metroSummaries.findOne({merchant: sale.merchant})
      Schema.metroSummaries.update metroSummary._id, $inc: incOption, $set: setOption

  @updateMetroSummaryByImport: (importId)->
    imports = Schema.imports.findOne(importId)
    importDetails = Schema.importDetails.find({import: imports._id, submitted: true}).fetch()
    totalProduct = 0
    for importDetail in importDetails
      totalProduct += importDetail.importQuality
    setOption={}
    option =
      importCount: 1
      importProductCount: totalProduct
      stockProductCount: totalProduct
      availableProductCount: totalProduct

    metroSummary = Schema.metroSummaries.findOne({merchant: imports.merchant})
    Schema.metroSummaries.update metroSummary._id, $inc: option, $set: setOption

  @updateMetroSummaryByTransaction: (merchant, depositCash)->
    metroSummary = Schema.metroSummaries.findOne({merchant: merchant})
    Schema.metroSummaries.update metroSummary._id, $inc: {
      saleDepositCash       : depositCash
      saleDebitCash         : -depositCash
      depositDay            : depositCash
      debitDay              : -depositCash

    }

  @updateMetroSummaryByNewTransaction: (merchant, debitCash)->
    metroSummary = Schema.metroSummaries.findOne({merchant: merchant})
    Schema.metroSummaries.update metroSummary._id, $inc: {
      saleDebitCash: debitCash
    }

  @updateMetroSummaryByDestroyTransaction: (merchant, debitCash)->
    metroSummary = Schema.metroSummaries.findOne({merchant: merchant})
    Schema.metroSummaries.update metroSummary._id, $inc: {
      saleDebitCash: -debitCash
    }

  @updateMetroSummaryByInventory: (inventoryId)->
    inventory = Schema.inventories.findOne({_id: inventoryId, finish: true})
    inventoryDetails = Schema.inventoryDetails.find({inventory: inventory._id}).fetch()
    lostQuality = 0
    for importDetail in inventoryDetails
      lostQuality += importDetail.lostQuality
    setOption={}
    option =
      inventoryCount        : 1
      inventoryProductCount : lostQuality
      stockProductCount     : -lostQuality
      availableProductCount : -lostQuality
    metroSummary = Schema.metroSummaries.findOne({merchant: inventory.merchant})
    Schema.metroSummaries.update metroSummary._id, $inc: option, $set: setOption

  @updateMetroSummaryByReturn: (returnId, returnQuality)->
    returns = Schema.returns.findOne(returnId)
    if returns
      setOption={}
      option =
        stockProductCount: returns.productQuality
        availableProductCount: returns.productQuality
        returnCount: 1
        returnProductCount: returns.productQuality
        returnCash: returns.totalPrice
      metroSummary = Schema.metroSummaries.findOne({merchant: returns.merchant})
      Schema.metroSummaries.update metroSummary._id, $inc: option, $set: setOption

  @updateMetroSummaryBySaleExport: (saleId)->
    if sale = Schema.sales.findOne(saleId)
      if saleStatusIsExport(sale)
        metroSummary = Schema.metroSummaries.findOne({merchant: sale.merchant})
        Schema.metroSummaries.update metroSummary._id, $inc: {stockProductCount: -sale.saleCount}

  @updateMetroSummaryBySaleImport: (saleId)->
    if sale = Schema.sales.findOne(saleId)
      if saleStatusIsImport(sale)
        metroSummary = Schema.metroSummaries.findOne({merchant: sale.merchant})
        Schema.metroSummaries.update metroSummary._id, $inc: {stockProductCount: sale.saleCount, availableProductCount: sale.saleCount }

  @updateMetroSummaryBy: (context)->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if profile
      if _.contains(context,'branch')
        merchantCount    = Schema.merchants.find({$or:[{_id: profile.parentMerchant},{parent: profile.parentMerchant}]})
      if _.contains(context,'warehouse') || _.contains(context,'branch')
        warehouseCount   = Schema.warehouses.find({merchant: profile.currentMerchant})
        warehouseCountAll= Schema.warehouses.find({$or:[{merchant: profile.parentMerchant },{parentMerchant: profile.parentMerchant}]})
      if _.contains(context,'staff')
        staffCount       = Schema.userProfiles.find({currentMerchant: profile.currentMerchant})
        staffCountAll    = Schema.userProfiles.find({parentMerchant: profile.parentMerchant})
      if _.contains(context,'customer')
        customerCount    = Schema.customers.find({currentMerchant: profile.currentMerchant})
        customerCountAll = Schema.customers.find({parentMerchant: profile.parentMerchant})
      if _.contains(context,'distributor')
        distributorCount = Schema.distributors.find({parentMerchant: profile.parentMerchant})
      if _.contains(context,'product')
        productCount = Schema.products.find({merchant: profile.currentMerchant})
      if _.contains(context,'partner')
        partnerCount = Schema.partners.find({parentMerchant: profile.parentMerchant})

      for item in Schema.metroSummaries.find({parentMerchant: profile.parentMerchant}).fetch()
        option = {}
        if _.contains(context,'branch')
          option.merchantCount = merchantCount.count()
        if _.contains(context,'warehouse') || _.contains(context,'branch')
          option.warehouseCount    = warehouseCount.count() if item.merchant == profile.currentMerchant
          option.warehouseCountAll = warehouseCountAll.count()
        if _.contains(context,'staff')
          option.staffCount    = staffCount.count() if item.merchant == profile.currentMerchant
          option.staffCountAll = staffCountAll.count()
        if _.contains(context,'customer')
          option.customerCount    = customerCount.count() if item.merchant == profile.currentMerchant
          option.customerCountAll = customerCountAll.count()
        if _.contains(context,'distributor')
          option.distributorCount = distributorCount.count()
        if _.contains(context,'product')
          option.productCount = productCount.count()
        if _.contains(context,'product')
          option.partnerCount = partnerCount.count()

        Schema.metroSummaries.update item._id, $set: option


  @updateMyMetroSummaryBy: (context, id)->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if profile
      option =
        salesMoneyDay: 0
        importMoneyDay: 0
        returnMoneyOfCustomerDay: 0
        returnMoneyOfDistributorDay: 0

      if _.contains(context,'createSale')
        saleFound = Schema.sales.findOne({_id: id, merchant: profile.currentMerchant})
        option.salesMoneyDay = saleFound.debtBalanceChange if saleFound
      if _.contains(context,'deleteSale')
        saleFound = Schema.sales.findOne({_id: id, merchant: profile.currentMerchant})
        option.salesMoneyDay = -saleFound.debtBalanceChange if saleFound

      if _.contains(context,'createdImport')
        importFound = Schema.imports.findOne({_id: id, merchant: profile.currentMerchant, finish: true, submitted: true})
        option.importMoneyDay = importFound.debtBalanceChange if importFound
      if _.contains(context,'deleteImport')
        importFound = Schema.imports.findOne({_id: id, merchant: profile.currentMerchant, finish: true, submitted: true})
        option.importMoneyDay = -importFound.debtBalanceChange if importFound

      if _.contains(context,'createReturn')
        returnFound = Schema.returns.findOne({_id: id, merchant: profile.currentMerchant, status: 2})
        if returnFound?.returnMethods is 0 then option.returnMoneyOfCustomerDay = returnFound.debtBalanceChange
        else option.returnMoneyOfDistributorDay = returnFound.debtBalanceChange
      if _.contains(context,'deleteReturn')
        returnFound = Schema.returns.findOne({_id: id, merchant: profile.currentMerchant, status: 2})
        if returnFound?.returnMethods is 0 then option.returnMoneyOfCustomerDay = -returnFound.debtBalanceChange
        else option.returnMoneyOfDistributorDay = -returnFound.debtBalanceChange

      if metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant})
        Schema.metroSummaries.update metroSummary._id, $inc: option

  @updateMyMetroSummaryByProfitability: ->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if profile
      profitabilityDay = 0
      metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant})
      toDate = new Date((new Date()).getFullYear(), (new Date()).getMonth(), (new Date()).getDate())
      Schema.sales.find({ merchant: profile.currentMerchant, 'version.createdAt': {$gte: toDate} }).forEach(
        (sale) ->
          Schema.saleDetails.find({sale: sale._id}).forEach(
            (saleDetail) ->
              if !saleDetail.totalCogs then saleDetail.totalCogs = 0
              profitabilityDay += saleDetail.finalPrice - saleDetail.totalCogs
          )
      )
      Schema.metroSummaries.update metroSummary._id, $set:{profitabilityDay: profitabilityDay}