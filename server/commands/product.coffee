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
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if profile
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