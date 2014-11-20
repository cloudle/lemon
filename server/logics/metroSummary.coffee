Meteor.methods
#  reCalculateMetroSummary: (id)->
#    metro = MetroSummary.findOne(id)
#    metro.updateMetroSummary()

  reCalculateMetroSummary: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant}) 
        merchantCount    = Schema.merchants.find({$or:[{_id: metroSummary.parentMerchant }, {parent: metroSummary.parentMerchant}]})
        warehouseCountAll= Schema.warehouses.find({$or:[{merchant: metroSummary.parentMerchant }, {parentMerchant: metroSummary.parentMerchant}]})
        warehouseCount   = Schema.warehouses.find({merchant: metroSummary.merchant})
        staffCount       = Schema.userProfiles.find({currentMerchant: metroSummary.merchant})
        staffCountAll    = Schema.userProfiles.find({parentMerchant: metroSummary.parentMerchant})
        customerCount    = Schema.customers.find({currentMerchant: metroSummary.merchant})
        customerCountAll = Schema.customers.find({parentMerchant: metroSummary.parentMerchant})
    
        products         = Schema.products.find({merchant: metroSummary.merchant })
        importCount      = Schema.imports.find({finish: true, merchant: metroSummary.merchant})
        saleCount        = Schema.sales.find({merchant: metroSummary.merchant })
        deliveryCount    = Schema.deliveries.find({merchant: metroSummary.merchant})
        inventoryCount   = Schema.inventories.find({success: true, merchant: metroSummary.merchant})
        returnCount      = Schema.returns.find({merchant: metroSummary.merchant, status: 2})
        transactionCount = Schema.transactions.find({merchant: metroSummary.merchant})
    
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
    
        Schema.metroSummaries.update metroSummary._id, $set: option

  checkProductExpireDate: (value, warehouseId = null)->
    timeOneDay = 86400000
    tempDate = new Date
    currentDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
    expireDate  = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate() + value)
    if warehouseId then optionWarehouse = {warehouse: warehouseId} else optionWarehouse = {}
    productDetails = Schema.productDetails.find({$and:[
      {merchant: @id}
      {expire:{$lte: expireDate}}
      {inStockQuality:{$gt: 0}}
      optionWarehouse
    ]}).fetch()

    for productDetail in productDetails
      product   = Schema.products.findOne(productDetail.product)
      warehouse = Schema.warehouses.findOne(productDetail.warehouse)
      date      = ((productDetail.expire).getTime() - currentDate.getTime())/timeOneDay

      currentProduct = {
        _id   : productDetail._id
        name  : product.name
        day   : date
        place : warehouse.name }

      Notification.productExpire(currentProduct)