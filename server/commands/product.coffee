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

      Schema.productDetails.update productDetail._id, $inc:{inStockQuality: -takenQuality, availableQuality: -takenQuality}
      Schema.products.update productDetail.product, $inc:{inStockQuality: -takenQuality, availableQuality: -takenQuality}

      transactionQuality += takenQuality
      if transactionQuality == salesQuality then break


Meteor.methods
  calculateAllProductTotalQualityAndAvailableQuality:->
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


#  insertProductAndRandomBarcode: (existedQuery, product)->
#    barcode = (Math.floor(Math.random() * 100000000000) + 89 *100000000000).toString()
#    existedQuery.productCode = barcode
#    Schema.products.findOne existedQuery