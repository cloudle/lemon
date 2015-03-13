subtractQualityOnSales = (branchProductId, saleDetail, productDetails, salesQuality)->
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
          branchProduct     : branchProductId
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
      Schema.branchProductSummaries.update branchProductId, $inc:{inStockQuality: -takenQuality, availableQuality: -takenQuality}

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
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      Schema.products.find({parentMerchant: profile.parentMerchant}).forEach(
        (product) ->
          productSalesQuality = {totalQuality: 0, availableQuality: 0, inStockQuality: 0}
          Schema.branchProductSummaries.find({product: product._id}).forEach(
            (branchProduct)->
              optionProduct = {totalQuality: 0, availableQuality: 0, inStockQuality: 0}
              Schema.productDetails.find({product: branchProduct.product, merchant: branchProduct.merchant}).forEach(
                (productDetail)->
                  optionProduct.totalQuality     += productDetail.importQuality
                  optionProduct.availableQuality += productDetail.availableQuality
                  optionProduct.inStockQuality   += productDetail.inStockQuality
              )
              Schema.branchProductSummaries.update branchProduct._id, $set: optionProduct

              productSalesQuality.totalQuality     += optionProduct.totalQuality
              productSalesQuality.availableQuality += optionProduct.availableQuality
              productSalesQuality.inStockQuality   += optionProduct.inStockQuality
          )
          console.log 'Product:' + product._id + ', Quality' + productSalesQuality
          Schema.products.update product._id, $set: productSalesQuality
      )


  calculateAllProductSalesQuality: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      Schema.products.find({parentMerchant: profile.parentMerchant}).forEach(
        (product) ->
          productSalesQuality = 0
          Schema.branchProductSummaries.find({product: product._id}).forEach(
            (branchProduct)->
              salesQuality = 0
              Schema.saleDetails.find({product: branchProduct.product}).forEach(
                (saleDetail)-> salesQuality += (saleDetail.quality - saleDetail.returnQuality)
              )
              productSalesQuality += salesQuality
              Schema.branchProductSummaries.update branchProduct._id, $set: {salesQuality: salesQuality}
          )
          console.log 'Product: ' + product._id + ', SaleQuality: ' + productSalesQuality
          Schema.products.update product._id, $set: {salesQuality: productSalesQuality}
      )



#      allMerchant  = Schema.merchants.find({$or:[{_id: profile.parentMerchant }, {parent: profile.parentMerchant}]}).fetch()
#      for merchant in allMerchant
#        for product in Schema.products.find({merchant: merchant._id}).fetch()
#          optionProduct ={salesQuality: 0}
#          optionProduct.salesQuality += (saleDetail.quality - saleDetail.returnQuality) for saleDetail in Schema.saleDetails.find({product: product._id}).fetch()
#          Schema.products.update product._id, $set: optionProduct

  updateProductBasicDetailMode: (branchProductId, mode = false)->
    if branchProduct = Schema.branchProductSummaries.findOne(branchProductId)
      if branchProduct.basicDetailModeEnabled != mode
        saleDetails = Schema.saleDetails.find({product: branchProduct.product}).fetch()
        importBasic = Schema.productDetails.find(
          {import: { $exists: false}, product: branchProduct.product}, {sort: {'version.createdAt': 1}}
        ).fetch()
        importProductDetails = Schema.productDetails.find(
          {import: { $exists: true}, product: branchProduct.product}, {sort: {'version.createdAt': 1}}
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
            inStockQuality  : productDetail.importQuality
            allowDelete     : false
          }
        Schema.branchProductSummaries.update branchProduct._id, $set: {
          totalQuality    : totalQuality
          availableQuality: totalQuality
          inStockQuality  : totalQuality
        }

        #tu dong tru san pham
        if countSaleQuality > countImportQuality
          console.log "So luong nhap kho du."
        else
          subtractQualityOnSales(branchProductId, detail, combinedImportDetails, (detail.quality - detail.returnQuality)) for detail in saleDetails
          Meteor.call 'checkProductValidation', branchProduct.product
          productOption = {availableQuality: 0, inStockQuality: 0, totalQuality: 0, salesQuality: 0, returnQualityByDistributor: 0, returnQualityByCustomer: 0}
          if newBranchProduct = Schema.branchProductSummaries.findOne(branchProductId)
            productOption.totalQuality     = newBranchProduct.totalQuality     - branchProduct.totalQuality
            productOption.inStockQuality   = newBranchProduct.inStockQuality   - branchProduct.inStockQuality
            productOption.availableQuality = newBranchProduct.availableQuality - branchProduct.availableQuality
            productOption.salesQuality     = newBranchProduct.salesQuality - branchProduct.salesQuality
            productOption.returnQualityByDistributor = newBranchProduct.returnQualityByDistributor - branchProduct.returnQualityByDistributor
            productOption.returnQualityByCustomer    = newBranchProduct.returnQualityByCustomer - branchProduct.returnQualityByCustomer
            Schema.branchProductSummaries.update newBranchProduct._id, $set: {basicDetailModeEnabled: false}
            Schema.products.update branchProduct.product, $inc: productOption

            console.log 'Ok, Ket thuc nhap ton dau ky.'

#          Schema.branchProductSummaries.find({product: branchProduct.product}).forEach(
#            (branchProduct) ->
#              productOption.inStockQuality   += branchProduct.inStockQuality
#              productOption.availableQuality += branchProduct.availableQuality
#          )
#          Schema.branchProductSummaries.update branchProduct._id, $set: {basicDetailModeEnabled: true}
#          Schema.products.update branchProduct.product, $set: productOption

  checkProductValidation: (id)->
    if product = Schema.products.findOne(id)
      if branchProduct = Schema.branchProductSummaries.findOne({product: product._id})
        branchProductOption = {availableQuality: 0, inStockQuality: 0, totalQuality: 0, salesQuality: 0, returnQualityByDistributor: 0, returnQualityByCustomer: 0}
        Schema.productDetails.find({product: product._id, merchant: product.merchant}).forEach(
          (productDetail)->
            branchProductOption.totalQuality += productDetail.importQuality if productDetail.importQuality
        )
        Schema.saleDetails.find({product: product._id}).forEach(
          (saleDetail)-> branchProductOption.salesQuality += saleDetail.quality
        )
        Schema.returnDetails.find({product: product._id}).forEach(
          (returnDetail) ->
            currentReturn = Schema.returns.findOne(returnDetail.return)
            if currentReturn.status is 2
              branchProductOption.returnQualityByCustomer += returnDetail.returnQuality if currentReturn.customer
              branchProductOption.returnQualityByDistributor += returnDetail.returnQuality if currentReturn.distributor
        )

        branchProductOption.totalQuality     = branchProductOption.totalQuality - branchProductOption.returnQualityByDistributor
        branchProductOption.availableQuality = branchProductOption.totalQuality - branchProductOption.salesQuality + branchProductOption.returnQualityByCustomer
        branchProductOption.inStockQuality   = branchProductOption.totalQuality - branchProductOption.salesQuality + branchProductOption.returnQualityByCustomer
        console.log product
        console.log branchProductOption
        Schema.branchProductSummaries.update branchProduct._id, $set:branchProductOption

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
          Schema.branchProductSummaries.update {product: product._id}, $set: productOption
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
              if branchProductId = Schema.branchProductSummaries.insert branchProductSummaryOption
                Meteor.call 'updateMetroSummaryBy', 'createBranchProduct', branchProductId
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

  uploadProductToGera: (productId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      product = Schema.products.findOne({_id: productId, parentMerchant: profile.parentMerchant, status: 'brandNew'})
      if Apps.Merchant.checkValidSyncProductToGera(product)
        buildInProductId = Schema.buildInProducts.insert BuildInProduct.optionByProduct(product)
        Schema.productUnits.find({product: product._id}).forEach(
          (productUnit) ->
            buildInProductUnitId = Schema.buildInProductUnits.insert BuildInProductUnit.optionByProductUnit(buildInProductId, productUnit)
            Schema.productUnits.update productUnit._id, $set:{buildInProductUnit: buildInProductUnitId}
        )
        Schema.products.update product._id, $set: {buildInProduct: buildInProductId, allowDelete: false, status: 'frozen'}
        #thông báo cho gera


  deleteBuildInProduct: (buildInProductId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if buildInProduct = Schema.buildInProducts.findOne({_id: buildInProductId})
        if buildInProduct.status is 'brandNew' || buildInProduct.status is 'copy'
          Schema.buildInProducts.remove buildInProduct._id
          Schema.buildInProductUnits.find({buildInProduct: buildInProduct._id}).forEach(
            (buildInProductUnit) -> Schema.buildInProductUnits.remove buildInProductUnit._id
          )
          if buildInProduct.status is 'copy'
            Schema.products.update buildInProduct.product, $set:{status: 'brandNew'}, $unset:{buildInProduct: true}
            Schema.merchants.update profile.parentMerchant, $pull:{ geraProduct: buildInProduct._id }

  submitBuildInProduct: (buildInProductId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if buildInProduct = Schema.buildInProducts.findOne({_id: buildInProductId})
        if buildInProduct.status is 'copy'
          if product = Schema.products.findOne({_id: buildInProduct.product})
            optionUnset = {basicUnit: true, productCode: true, name: true, image: true}
            Schema.products.update product._id, $set:{status: "onSold"}, $unset: optionUnset
            Schema.buildInProducts.update buildInProduct._id, $set:{status: "onSold"}, $push:{ merchantRegister: profile.parentMerchant }
            Schema.merchantProfiles.update {merchant: profile.parentMerchant}, $push:{ geraProduct: buildInProduct._id }
            Schema.buildInProductUnits.find({buildInProduct: buildInProduct._id}).forEach(
              (buildInProductUnit) ->
                productUnit = Schema.productUnits.findOne({product: buildInProduct.product, buildInProductUnit: buildInProductUnit._id})
                if productUnit
                  optionUnset = {productCode: true, image: true, unit: true, conversionQuality: true}
                  Schema.productUnits.update productUnit._id, $unset: optionUnset
                else
                  optionProductUnit =
                    buildInProductUnit: buildInProductUnit._id
                    parentMerchant    : product.parentMerchant
                    merchant          : product.merchant
                    createMerchant    : product.parentMerchant
                    product           : product._id
                    allowDelete       : false
                  Schema.productUnits.insert optionProductUnit
            )

  deleteMerchantProduct: (productId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if product = Schema.products.findOne({_id: productId, parentMerchant: profile.parentMerchant})
        if product.branchList.length is 0
          Schema.products.remove product._id
          Schema.productUnits.remove {product: product._id}
          Schema.branchProductSummaries.remove {product: product._id}
          Schema.branchProductUnits.remove {product: product._id}
          Meteor.call 'updateMetroSummaryBy', 'deleteMerchantProduct', product

  deleteBranchProduct: (productId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      branchProfile = Schema.branchProfiles.findOne({merchant: profile.currentMerchant})
      branchProduct = Schema.branchProductSummaries.findOne({product: productId, merchant: profile.currentMerchant})
      if branchProduct and branchProfile
        if branchProduct.inStockQuality == branchProduct.availableQuality == branchProduct.totalQuality == branchProduct.salesQuality == 0
          Schema.branchProductUnits.remove {product: branchProduct.product, merchant: profile.currentMerchant}
          Schema.branchProductSummaries.remove {product: branchProduct.product, merchant: profile.currentMerchant}
          Meteor.call 'updateMetroSummaryBy', 'deleteBranchProduct', branchProduct.product, branchProduct.merchant

  addBranchProduct: (productId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if product = Schema.products.findOne({_id: productId, parentMerchant: profile.parentMerchant})
        branchProductOption =
          parentMerchant: profile.parentMerchant
          merchant      : profile.currentMerchant
          warehouse     : profile.currentWarehouse
          product       : product._id
        branchProductOption.buildInProduct = product.buildInProduct if product.buildInProduct
        if !branchProduct = Schema.branchProductSummaries.findOne branchProductOption
          branchProduct = Schema.branchProductSummaries.findOne(Schema.branchProductSummaries.insert branchProductOption)
          Schema.productUnits.find({product: product._id}).forEach(
            (productUnit)-> Schema.branchProductUnits.insert BranchProductUnit.optionByProfile(product._id, productUnit._id, profile)
          )
        Meteor.call 'updateMetroSummaryBy', 'createBranchProduct', branchProduct

  getBuildInProduct: (buildInProductId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      buildInProduct = Schema.buildInProducts.findOne({_id: buildInProductId})
      productFound   = Schema.products.findOne({buildInProduct: buildInProductId, parentMerchant: profile.parentMerchant})
      if buildInProduct and !productFound
        if productId = Schema.products.insert Product.optionByProfile(buildInProductId, profile)
          Schema.buildInProductUnits.find({buildInProduct: buildInProduct._id}).forEach(
            (buildInProductUnit)->
              productUnitId = Schema.productUnits.insert ProductUnit.optionByProfile(productId, buildInProductUnit, profile)
              Schema.branchProductUnits.insert BranchProductUnit.optionByProfile(productId, productUnitId, profile) if productUnitId
          )
          branchProductId = Schema.branchProductSummaries.insert BranchProductSummary.optionByProfile(productId, buildInProductId, profile)
          Meteor.call 'updateMetroSummaryBy', 'createBranchProduct', branchProductId
