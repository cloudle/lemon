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
      saleDetails = Schema.saleDetails.find({sale: sale._id})
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

        depositDay            : sale.deposit
        debitDay              : sale.debit
        discountDay           : sale.totalPrice - sale.finalPrice
        revenueDay            : sale.finalPrice
        cogsDay               : 0

      if sale.paymentsDelivery is 1
        incOption.deliveryCount        = 1
        incOption.deliveryProductCount = sale.saleCount

      incOption.cogsDay += detail.totalCogs for detail in saleDetails.fetch()
      incOption.profitabilityDay = sale.finalPrice - incOption.cogsDay
#
#      oldSale = Schema.sales.findOne({$and: [
#        {merchant: sale.merchant}
#        {'version.createdAt': {$lt: sale.version.createdAt}}
#      ]}, {sort: {'version.createdAt': -1}})

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

#      oldImports = Schema.imports.findOne({$and: [
#        {merchant: imports.merchant}
#        {'version.updateAt': {$lt: imports.version.updateAt}}
#        {submitted: true}
#      ]}, Sky.helpers.defaultSort())
#      console.log imports.version.updateAt.getDate()
#      console.log oldImports
#
#      unless oldImports
#        oldImports = {version: {}}
#        oldImports.version.updateAt = imports.version.updateAt
#
#      if imports.version.updateAt.getDate() == oldImports.version.updateAt.getDate()
#        option.importCountDay = totalProduct
#      else
#        setOption.importCountDay = totalProduct
#
#      if imports.version.updateAt.getMonth() == oldImports.version.updateAt.getMonth()
#        option.importCountMonth = totalProduct
#      else
#        setOption.importCountMonth = totalProduct

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

    #  oldImports = Schema.imports.findOne({$and: [
    #    {merchant: imports.merchant}
    #    {'version.updateAt': {$lt: imports.version.updateAt}}
    #    {submitted: true}
    #  ]}, Sky.helpers.defaultSort())
    #  console.log imports.version.updateAt.getDate()
    #  console.log oldImports
    #
    #  unless oldImports
    #    oldImports = {version: {}}
    #    oldImports.version.updateAt = imports.version.updateAt

    #  if imports.version.updateAt.getDate() == oldImports.version.updateAt.getDate()
    #    option.importCountDay = totalProduct
    #  else
    #    setOption.importCountDay = totalProduct
    #
    #  if imports.version.updateAt.getMonth() == oldImports.version.updateAt.getMonth()
    #    option.importCountMonth = totalProduct
    #  else
    #    setOption.importCountMonth = totalProduct

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
#            oldReturn = Schema.returns.findOne({$and: [
#              {merchant: returns.merchant}
#              {'version.updateAt': {$lt: returns.version.updateAt}}
#              {status: 2}
#            ]}, Sky.helpers.defaultSort())
#
#            unless oldReturn
#              oldReturn = {version: {}}
#              oldReturn.version.updateAt = sale.version.updateAt
#
#            if returns.version.updateAt.getDate() == oldReturn.version.updateAt.getDate()
#              option.returnCountDay     = returns.productQuality
#              option.returnCashDay = returns.totalPrice
#            else
#              setOption.returnCountDay     = returns.productQuality
#              setOption.returnCashDay = returns.totalPrice
#
#            if returns.version.updateAt.getMonth() == oldReturn.version.updateAt.getMonth()
#              option.returnCountMonth     = returns.productQuality
#              option.returnCashMonth = returns.totalPrice
#            else
#              setOption.returnCountMonth     = returns.productQuality
#              setOption.returnCashMonth = returns.totalPrice
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

      metroSummary = Schema.metroSummaries.find({parentMerchant: profile.parentMerchant})
      for item in metroSummary.fetch()
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

        Schema.metroSummaries.update item._id, $set: option


