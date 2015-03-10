Meteor.methods
  reCalculateMetroSummaryTotalReceivableCash: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      metroSummaries = Schema.metroSummaries.find({parentMerchant: profile.parentMerchant}).fetch()
      if metroSummaries.length > 0
        totalSaleReceivableCash = 0
        for customer in Schema.customers.find({parentMerchant: profile.parentMerchant}).fetch()
          receivableCash = customer.customSaleDebt + customer.saleDebt
          totalSaleReceivableCash += receivableCash if receivableCash > 0
      Schema.metroSummaries.update(metroSummary._id, $set:{totalReceivableCash: totalSaleReceivableCash}) for metroSummary in metroSummaries

  reCalculateMetroSummaryTotalPayableCash: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      metroSummaries = Schema.metroSummaries.find({parentMerchant: profile.parentMerchant}).fetch()
      if metroSummaries.length > 0
        totalImportPayableCash = 0
        for distributor in Schema.distributors.find({parentMerchant: profile.parentMerchant}).fetch()
          payableCash = distributor.customImportDebt + distributor.importDebt
          totalImportPayableCash += payableCash if payableCash > 0
      Schema.metroSummaries.update(metroSummary._id, $set:{totalPayableCash: totalImportPayableCash}) for metroSummary in metroSummaries

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
    
        products         = Schema.products.find({merchant: metroSummary.merchant})
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
#            saleDepositCash += item.depositCash
#            saleDebitCash   += item.debitCash
            saleRevenueCash += item.totalCash
          if item.group is 'import'
#            importDepositCash += item.depositCash
#            importDebitCash   += item.debitCash
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

  calculateMetroSummaryRevenueDay: ->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if profile
      toDate = new Date((new Date()).getFullYear(), (new Date()).getMonth(), (new Date()).getDate())
      option =
        salesMoneyDay : 0
        importMoneyDay: 0
        returnMoneyOfDistributorDay: 0
        returnMoneyOfCustomerDay   : 0

      Schema.sales.find({ merchant: profile.currentMerchant, 'version.createdAt': {$gte: toDate} }).forEach(
        (sale) -> option.salesMoneyDay += sale.debtBalanceChange
      )

      Schema.imports.find({ merchant: profile.currentMerchant, 'version.createdAt': {$gte: toDate}, finish: true, submitted: true}).forEach(
        (currentImport) -> option.importMoneyDay += currentImport.debtBalanceChange
      )

      Schema.returns.find({ merchant: profile.currentMerchant, 'version.createdAt': {$gte: toDate}, status: 2 }).forEach(
        (currentReturn) ->
          if currentReturn.returnMethods is 0
            option.returnMoneyOfCustomerDay += currentReturn.debtBalanceChange
          else
            option.returnMoneyOfDistributorDay += currentReturn.debtBalanceChange
      )

      Schema.metroSummaries.update({merchant: profile.currentMerchant},{$set: option})

  updateMetroSummaryBy: (context, item = undefined, merchantId = undefined)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      merchantProfile = Schema.merchantProfiles.findOne {merchant: profile.parentMerchant}
      if merchantProfile
        merchantId = profile.currentMerchant if _.contains(merchantProfile.merchantList, merchantId) is false

        if typeof item is "string" then itemId = item
        else if typeof item is "object" then itemId = item._id
        else itemId = undefined

        if itemId
          if context is 'createCustomer'
            itemFound = Schema.customers.findOne {_id: itemId, parentMerchant: profile.parentMerchant }
            metroAndMerchant_addToSetOption = {customerList: itemId} if itemFound
          else if context is 'deleteCustomer'
            metroAndMerchant_pullOption = {customerList: itemId} if !Schema.customers.findOne itemId

          else if context is 'createDistributor'
            itemFound = Schema.distributors.findOne {_id: itemId, parentMerchant: profile.parentMerchant }
            metroAndMerchant_addToSetOption = {distributorList: itemId} if itemFound
          else if context is 'deleteDistributor'
            metroAndMerchant_pullOption = {distributorList: itemId} if !Schema.distributors.findOne itemId

          else if context is 'createBranchProduct'
            if itemFound = Schema.branchProductSummaries.findOne {_id: itemId, parentMerchant: profile.parentMerchant }
              metroAndMerchant_addToSetOption = {productList: itemFound.product}
              metroAndMerchant_addToSetOption.geraProductList = itemFound.buildInProduct if itemFound.buildInProduct
              Schema.products.update itemFound.product, $addToSet: { branchList: merchantId }
          else if context is 'deleteBranchProduct'
            product = Schema.products.findOne({_id: itemId, parentMerchant: profile.parentMerchant})
            branch  = Schema.branchProductSummaries.findOne {product: itemId, merchant: merchantId }
            if product and !branch
                if product.branchList.length is 1 and _.contains(product.branchList, merchantId)
                  metro_pullOption = {productList: product._id}
                  metro_pullOption.geraProductList = product.buildInProduct if product.buildInProduct
                else if product.branchList.length > 1 and _.contains(product.branchList, merchantId)
                  metroAndMerchant_pullOption = {productList: product._id}
                  metroAndMerchant_pullOption.geraProductList = product.buildInProduct if product.buildInProduct
                Schema.products.update product._id, $pull: { branchList: merchantId }
          else if context is 'deleteMerchantProduct'
            if !Schema.products.findOne({_id: itemId, parentMerchant: profile.parentMerchant})
              merchant_pullOption = {productList: item._id}
              merchant_pullOption.geraProductList = item.buildInProduct if item.buildInProduct
              Schema.metroSummaries.update { merchant: {$in:merchantProfile.merchantList} }, $pull: merchant_pullOption

          else if context is 'createSale'
            if Schema.sales.findOne({_id: itemId, merchant: merchantId})
              Schema.metroSummaries.update {merchant: merchantId}, $addToSet: {saleDay: itemId, saleMonth: itemId}

          else if context is 'deleteSale'
            if !Schema.sales.findOne({_id: itemId, merchant: merchantId})
              Schema.metroSummaries.update {merchant: merchantId}, $pull: {saleDay: itemId, saleMonth: itemId}

          else if context is 'createImport'
            if Schema.imports.findOne({_id: itemId, merchant: merchantId, finish: true, submitted: true, status: 'success'})
              Schema.metroSummaries.update {merchant: merchantId}, $addToSet: {importDay: itemId, importMonth: itemId}

          else if context is 'deleteImport'
            if !Schema.imports.findOne({_id: itemId, merchant: merchantId, finish: true, submitted: true, status: 'success'})
              Schema.metroSummaries.update {merchant: merchantId}, $pull: {importDay: itemId, importMonth: itemId}

          else if context is 'createReturnCustomer'
            if Schema.returns.findOne({_id: itemId, merchant: merchantId, status: 2, customer: {$exists: true}})
              Schema.metroSummaries.update {merchant: merchantId}, $addToSet: {returnCustomerDay: itemId, returnCustomerMonth: itemId}

          else if context is 'createReturnDistributor'
            if Schema.returns.findOne({_id: itemId, merchant: merchantId, status: 2, distributor: {$exists: true}})
              Schema.metroSummaries.update {merchant: merchantId}, $addToSet: {returnDistributorDay: itemId, returnDistributorMonth: itemId}

  #        else if context is 'createDelivery'
  #        else if context is 'createInventory'
  #        else if context is 'createTransfer'

          if metroAndMerchant_addToSetOption
            Schema.metroSummaries.update {merchant: merchantId}, $addToSet:  metroAndMerchant_addToSetOption
            Schema.merchantProfiles.update merchantProfile._id, $addToSet: metroAndMerchant_addToSetOption
          if metroAndMerchant_pullOption
            Schema.metroSummaries.update {merchant: merchantId}, $pull: metroAndMerchant_pullOption
            Schema.merchantProfiles.update merchantProfile._id, $pull: metroAndMerchant_pullOption

          Schema.metroSummaries.update {merchant: merchantId}, $pull: metro_pullOption if metro_pullOption
          Schema.merchantProfiles.update merchantProfile._id, $pull: merchant_pullOption if merchant_pullOption

