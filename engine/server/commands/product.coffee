subtractQualityOnSales = (saleDetail, productDetails, salesQuality)->
  transactionQuality = 0
  for productDetail in productDetails
    productDetail = Schema.productDetails.findOne(productDetail._id)
    if productDetail.availableQuality > 0
      requiredQuality = salesQuality - transactionQuality
      if productDetail.availableQuality >= requiredQuality
        takenQuality = requiredQuality
        Schema.saleDetails.update saleDetail._id, $set:{productDetail: productDetail._id}
      else
        takenQuality = productDetail.availableQuality
        newSaleDetail =
          sale              : saleDetail.sale
          product           : saleDetail.product
          productDetail     : productDetail._id
          quality           : takenQuality
          returnQuality     : 0
          price             : saleDetail.price
          discountPercent   : saleDetail.discountPercent
          export            : false
          status            : false
          unitPrice         : saleDetail.unitPrice
          conversionQuality : saleDetail.conversionQuality

        newSaleDetail.unitQuality  = takenQuality/newSaleDetail.conversionQuality
        newSaleDetail.totalPrice   = takenQuality*saleDetail.price
        newSaleDetail.discountCash = newSaleDetail.totalPrice*saleDetail.discountPercent/100
        newSaleDetail.finalPrice   = newSaleDetail.totalPrice - newSaleDetail.discountCash

        newSaleDetail.unit       = saleDetail.unit if saleDetail.unit
        newSaleDetail.export     = saleDetail.export if saleDetail.export
        newSaleDetail.exportDate = saleDetail.exportDate if saleDetail.exportDate
        Schema.saleDetails.insert newSaleDetail

        saleDetailOption =
          quality      : -newSaleDetail.quality
          unitQuality  : -newSaleDetail.unitQuality
          totalPrice   : -newSaleDetail.totalPrice
          discountCash : -newSaleDetail.discountCash
          finalPrice   : -newSaleDetail.finalPrice
        Schema.saleDetails.update saleDetail._id, $unset:{productDetail: true}, $inc:saleDetailOption

      Schema.productDetails.update productDetail._id, $set:{allowDelete: false}, $inc:{inStockQuality: -takenQuality, availableQuality: -takenQuality}
      Schema.products.update productDetail.product, $inc:{inStockQuality: -takenQuality, availableQuality: -takenQuality}

      transactionQuality += takenQuality
      if transactionQuality == salesQuality then break

setOption = (type, smallerUnit, currentUnit, detail)->
  if type is 'saleDetail'
    option =
      conversionQuality: detail.conversionQuality*smallerUnit.conversionQuality
      price            : detail.price/smallerUnit.conversionQuality
      quality          : detail.quality*smallerUnit.conversionQuality
      returnQuality    : detail.returnQuality*smallerUnit.conversionQuality
    option.unit = smallerUnit._id if smallerUnit._id is currentUnit._id

  else if type is 'productDetail'
    option =
      conversionQuality: detail.conversionQuality*smallerUnit.conversionQuality
      importQuality    : detail.importQuality*smallerUnit.conversionQuality
      availableQuality : detail.availableQuality*smallerUnit.conversionQuality
      inStockQuality   : detail.inStockQuality*smallerUnit.conversionQuality
    option.unit = smallerUnit._id if smallerUnit._id is currentUnit._id

  else if type is 'returnDetail'
    option =
      conversionQuality: detail.conversionQuality*smallerUnit.conversionQuality
      price            : detail.price/smallerUnit.conversionQuality
      returnQuality    : detail.returnQuality*smallerUnit.conversionQuality
    option.unit = smallerUnit._id if smallerUnit._id is currentUnit._id

  return option



Meteor.methods
  calculateAllProductTotalQualityAndAvailableQuality: ->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if profile
      allMerchant  = Schema.merchants.find({$or:[{_id: profile.parentMerchant }, {parent: profile.parentMerchant}]}).fetch()
      for merchant in allMerchant
        for product in Schema.products.find({merchant: merchant._id}).fetch()
          optionProduct ={totalQuality: 0, availableQuality: 0, inStockQuality: 0}
          for productDetail in Schema.productDetails.find({product: product._id}).fetch()
            optionProduct.totalQuality     += productDetail.importQuality
            optionProduct.availableQuality += productDetail.availableQuality
            optionProduct.inStockQuality   += productDetail.inStockQuality
          Schema.products.update product._id, $set: optionProduct

  calculateAllProductSalesQuality: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      allMerchant  = Schema.merchants.find({$or:[{_id: profile.parentMerchant }, {parent: profile.parentMerchant}]}).fetch()
      for merchant in allMerchant
        for product in Schema.products.find({merchant: merchant._id}).fetch()
          optionProduct ={salesQuality: 0}
          optionProduct.salesQuality += (saleDetail.quality - saleDetail.returnQuality) for saleDetail in Schema.saleDetails.find({product: product._id}).fetch()
          Schema.products.update product._id, $set: optionProduct

  updateProductBasicDetailMode: (productId, mode = false)->
    if product = Schema.products.findOne(productId)
      if product.basicDetailModeEnabled != mode
        saleDetails = Schema.saleDetails.find({product: product._id}).fetch()

        importBasic = Schema.productDetails.find(
          {import: { $exists: false}, product: product._id}, {sort: {'version.createdAt': 1}}
        ).fetch()
        importProductDetails = Schema.productDetails.find(
          {import: { $exists: true}, product: product._id}, {sort: {'version.createdAt': 1}}
        ).fetch()

        combinedImportDetails = importBasic.concat(importProductDetails)

        #kiem tra so luong
        countSaleQuality = 0
        countSaleQuality += (detail.quality - detail.returnQuality) for detail in saleDetails

        countImportQuality = 0
        countImportQuality += detail.importQuality for detail in combinedImportDetails

        #cap nhat du lieu san phan ban dau
        totalQuality = 0
        for productDetail in combinedImportDetails
          totalQuality += productDetail.importQuality
          Schema.productDetails.update productDetail._id, $set:{
            availableQuality: productDetail.importQuality
            inStockQuality:   productDetail.importQuality
            allowDelete: false
          }
        Schema.products.update product, $set: {
          totalQuality:     totalQuality
          availableQuality: totalQuality
          inStockQuality:   totalQuality
        }

        #tu dong tru san pham
        if countSaleQuality > countImportQuality
          console.log "So luong nhap kho du."
        else
          subtractQualityOnSales(detail, combinedImportDetails, (detail.quality - detail.returnQuality)) for detail in saleDetails
          Schema.products.update product._id, $set:{basicDetailModeEnabled: mode}

  updateProductBasicDetailMode01: (productId, mode = false)->
    if product = Schema.products.findOne(productId)
      if product.basicDetailModeEnabled != mode
        productDetailList = []
        totalImportQuality = 0
        totalQuality = 0
        Schema.productDetails.find({product: product._id}).forEach(
          (detail) ->
            Schema.productDetails.update detail, $set:{allowDelete: false}
            totalImportQuality += detail.importQuality
        )
        saleDetails = Schema.saleDetails.find({product: product._id}).fetch()
        if saleDetails.length > 0
          totalQuality += (detail.quality - detail.returnQuality) for detail in saleDetails
#          productGroup = _.chain(saleDetails)
#          .groupBy("unit")
#          .map (group, key) ->
#            return {
#            product: key
#            quality: _.reduce(group, ((res, current) -> res + (current.quality - current.returnQuality) ), 0)
#            }
#          .value()

#          for item in productGroup
#            if item.product is "undefined"
#              detailOption =
#                merchant          : product.merchant
#                warehouse         : product.warehouse
#                product           : product._id
#                unitPrice         : product.importPrice ? 0
#                importPrice       : product.importPrice ? 0
#                unitQuality       : item.quality
#                conversionQuality : 1
#                importQuality     : item.quality
#                availableQuality  : item.quality
#                inStockQuality    : item.quality
#            else
#              productUnit = Schema.productUnits.findOne({_id: item.product, product: product._id})
#                detailOption =
#                  merchant          : product.merchant
#                  warehouse         : product.warehouse
#                  product           : product._id
#                  unitPrice         : productUnit.importPrice
#                  importPrice       : productUnit.importPrice
#                  unitQuality       : item.quality/productUnit.conversionQuality
#                  unit              : productUnit._id
#                  conversionQuality : productUnit.conversionQuality
#                  importQuality     : item.quality
#                  availableQuality  : item.quality
#                  inStockQuality    : item.quality
          detailOption =
            merchant          : product.merchant
            warehouse         : product.warehouse
            product           : product._id
            unitPrice         : product.importPrice ? 0
            importPrice       : product.importPrice ? 0
            unitQuality       : totalQuality
            conversionQuality : 1
            importQuality     : totalQuality
            availableQuality  : totalQuality
            inStockQuality    : totalQuality

          if detailOption
            productDetailId = Schema.productDetails.insert detailOption
            if Schema.productDetails.findOne(productDetailId)
              productDetailList.push(productDetailId)
              Schema.productUnits.update detailOption.unit, $set:{allowDelete: false} if detailOption.unit

          importBasic = Schema.productDetails.find({_id: {$in:productDetailList} }).fetch()
          subtractQualityOnSales(detail, importBasic, (detail.quality - detail.returnQuality)) for detail in saleDetails
          Schema.products.update product._id, $set:{
            basicDetailModeEnabled: mode
            allowDelete     : false
            totalQuality    : totalImportQuality + totalQuality
            availableQuality: totalImportQuality
            inStockQuality  : totalImportQuality
          }

  changedSmallerUnit: (productId, unitId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if product = Schema.products.findOne({_id: productId, merchant: profile.currentMerchant})
        if smallerUnit = Schema.productUnits.findOne({_id: unitId, product: product._id, allowDelete: true})
          #Tim tat cac du lieu lien qua toi DVT co ban
          Schema.orderDetails.find({product: product._id, unit:{$exists: false}}).forEach(
            (detail) -> Schema.orderDetails.update detail._id, $set: setOption('saleDetail', smallerUnit, smallerUnit, detail))

          Schema.saleDetails.find({product: product._id, unit:{$exists: false}}).forEach(
            (detail) -> Schema.saleDetails.update detail._id, $set: setOption('saleDetail', smallerUnit, smallerUnit, detail))

          Schema.importDetails.find({product: product._id, unit:{$exists: false}}).forEach(
            (detail) -> Schema.importDetails.update detail._id, $set: setOption('productDetail', smallerUnit, smallerUnit, detail))

          Schema.productDetails.find({product: product._id, unit:{$exists: false}}).forEach(
            (detail) -> Schema.productDetails.update detail._id, $set: setOption('productDetail', smallerUnit, smallerUnit, detail))

          Schema.returnDetails.find({product: product._id, unit:{$exists: false}}).forEach(
            (detail) -> Schema.returnDetails.update detail._id, $set: setOption('returnDetail', smallerUnit, smallerUnit, detail))

          #Cap nhat product
          productOption =
            basicUnit       : smallerUnit.unit
            productCode     : smallerUnit.productCode
            price           : smallerUnit.price
            importPrice     : smallerUnit.importPrice
            salesQuality    : product.salesQuality*smallerUnit.conversionQuality
            totalQuality    : product.totalQuality*smallerUnit.conversionQuality
            availableQuality: product.availableQuality*smallerUnit.conversionQuality
            inStockQuality  : product.inStockQuality*smallerUnit.conversionQuality

          smallerUnitOption =
            productCode      : product.productCode
            unit             : product.basicUnit
            conversionQuality: smallerUnit.conversionQuality
            price            : product.price
            importPrice      : product.importPrice
            allowDelete      : product.allowDelete
            smallerUnit      : false

          Schema.products.update product._id, $set: productOption
          Schema.productUnits.update smallerUnit._id, $set: smallerUnitOption

          #Cap nhat productUnit co lai
          Schema.productUnits.find({_id: { $ne: smallerUnit._id }, product: product._id}).forEach(
            (productUnit) ->
              Schema.orderDetails.find({product: product._id, unit: productUnit._id}).forEach(
                (detail) -> Schema.orderDetails.update detail._id, $set: setOption('saleDetail', smallerUnit, productUnit, detail))

              Schema.saleDetails.find({product: product._id, unit: productUnit._id}).forEach(
                (detail) -> Schema.saleDetails.update detail._id, $set: setOption('saleDetail', smallerUnit, productUnit, detail))

              Schema.importDetails.find({product: product._id, unit: productUnit._id}).forEach(
                (detail) -> Schema.importDetails.update detail._id, $set: setOption('productDetail', smallerUnit, productUnit, detail))

              Schema.productDetails.find({product: product._id, unit: productUnit._id}).forEach(
                (detail) -> Schema.productDetails.update detail._id, $set: setOption('productDetail', smallerUnit, productUnit, detail))

              Schema.returnDetails.find({product: product._id, unit: productUnit._id}).forEach(
                (detail) -> Schema.returnDetails.update detail._id, $set: setOption('returnDetail', smallerUnit, productUnit, detail))

              Schema.productUnits.update productUnit._id, $set:{conversionQuality: productUnit.conversionQuality*smallerUnit.conversionQuality}
          )

          return smallerUnitOption

  calculateSaleDetailByTotalCogs: ->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if profile
      toDate = new Date((new Date()).getFullYear(), (new Date()).getMonth(), (new Date()).getDate())
      Schema.sales.find({merchant: profile.currentMerchant, 'version.createdAt': {$gte: toDate} }).forEach(
        (sale) ->
          Schema.saleDetails.find({sale: sale._id}).forEach(
            (saleDetail) ->
              if saleDetail.productDetail
                productDetail = Schema.productDetails.findOne(saleDetail.productDetail)
                totalCogs = Math.round(saleDetail.quality * productDetail.importPrice)
              else
                if saleDetail.unit
                  totalCogs = Math.round((saleDetail.quality/saleDetail.conversionQuality) * Schema.productUnits.findOne(saleDetail.unit)?.importPrice)
                else
                  totalCogs = Math.round((saleDetail.quality/saleDetail.conversionQuality) * Schema.products.findOne(saleDetail.product)?.importPrice)

              Schema.saleDetails.update saleDetail._id, $set:{totalCogs: totalCogs}
          )
      )

  calculateProductImportPrice: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      Schema.productDetails.find({merchant: profile.currentMerchant}).forEach(
        (detail) -> Schema.productDetails.update detail._id, $set:{importPrice: detail.unitPrice/detail.conversionQuality}
      )

  createBranchProductSummaryBy: (productId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if product = Schema.products.findOne({_id: productId, parentMerchant: profile.parentMerchant})
        Schema.merchants.find({$or: [{_id: product.parentMerchant}, {parent: product.parentMerchant}] }).forEach(
          (branch)->
            branchProductSummaryOption =
              parentMerchant : product.parentMerchant
              merchant       : branch._id
              product        : product._id

            if !Schema.branchProductSummaries.findOne(branchProductSummaryOption)
              Schema.branchProductSummaries.insert branchProductSummaryOption
        )

  deleteBranchProductSummaryBy: (productId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      product = Schema.products.findOne({_id: productId, parentMerchant: profile.parentMerchant, buildInProduct:{$exists: false}})
      if product?.allowDelete
        Schema.merchants.find({$or: [{_id: product.parentMerchant}, {parent: product.parentMerchant}] }).forEach(
          (branch)->
            if branchProductSummary = Schema.branchProductSummaries.findOne({merchant: branch._id, product: product._id})
              Schema.branchProductSummaries.remove branchProductSummary._id
        )
        Schema.products.remove product._id

  createProductUnitBy: (productUnitOption)->
    if productUnitId = Schema.productUnits.insert productUnitOption
      Schema.branchProductSummaries.find({product: productUnitOption.product}).forEach(
        (branchProduct)->
          productUnitOption.merchant    = branchProduct.merchant
          productUnitOption.productUnit = productUnitId
          Schema.branchProductUnits.insert productUnitOption
      )
      return productUnitId

  deleteProductUnit: (productUnit)->
    if !productUnit.buildInProductUnit and productUnit.allowDelete
      Schema.branchProductUnits.find({productUnit: productUnit._id}).forEach(
        (branchProduct) -> Schema.branchProductUnits.remove(branchProduct._id) )
      Schema.productUnits.remove(productUnit._id)