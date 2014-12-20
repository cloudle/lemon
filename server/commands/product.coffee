subtractQualityOnSales = (saleDetail, productDetails)->
#  if transactionQuality < detail.quality
#    productDetails = _.filter(importBasic, (item)-> item.availableQuality > 0)
#    for productDetail in productDetails
#      requiredQuality = saleDetail.quality - transactionQuality
#      if productDetail.availableQuality > requiredQuality
#        takenQuality = requiredQuality
#        Schema.saleDetails.update saleDetail._id, $set:{productDetail: productDetail._id}
#      else
#        takenQuality = productDetail.availableQuality
#        #tao ra 2 phieu
#        optionSaleDetail =
#          sale              : saleDetail.sale
#          product           : saleDetail.product
#          quality           : takenQuality
#          returnQuality     : 0
#          price             : saleDetail.price
#          discountPercent   : saleDetail.discountPercent
#          export            : false
#          status            : false
#          export            : saleDetail.export
#          exportDate        : saleDetail.exportDate
#          unitPrice         : saleDetail.unitPrice
#          conversionQuality : saleDetail.conversionQuality
#
#        optionSaleDetail.unit = saleDetail.unit if saleDetail.unit
#
#        optionSaleDetail.discountCash: saleDetail.discountCash
#        optionSaleDetail.totalPrice  : saleDetail.totalPrice
#        optionSaleDetail.finalPrice  : saleDetail.finalPrice
#
#        optionSaleDetail.unitQuality : saleDetail.unitQuality
#
#
#
#
#
#
#        Schema.saleDetails.update saleDetail._id,
#
#      Schema.productDetails.update productDetail._id, $inc:{inStockQuality: -takenQuality, availableQuality: -takenQuality}
#      Schema.products.update productDetail.product, $inc:{inStockQuality: -takenQuality,availableQuality: -takenQuality}
#
#      transactionQuality += takenQuality
#      if transactionQuality == saleDetail.quality then break
#    return transactionQuality


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

        importBasic = Schema.productDetails.find({import: { $exists: false}, product: product._id}).fetch()
        productDetails = Schema.productDetails.find({import: { $exists: true}, product: product._id}).fetch()
        combinedImportDetails = importBasic.concat(productDetails)

        countSaleQuality = 0
        countSaleQuality += detail.quality for detail in saleDetails

        countImportQuality = 0
        countImportQuality += detail.importQuality for detail in combinedImportDetails


#        if countSaleQuality > countImportQuality
#          console.log "So luong nhap kho du."
#        else
#          for detail in saleDetails
#            transactionQuality = 0
#            transactionQuality = subtractQualityOnSales(detail, importBasic)
#            if transactionQuality < detail.quality
#              transactionQuality = subtractQualityOnSales(detail, productDetails)

        console.log countSaleQuality
        console.log combinedImportDetails

#  insertProductAndRandomBarcode: (existedQuery, product)->
#    barcode = (Math.floor(Math.random() * 100000000000) + 89 *100000000000).toString()
#    existedQuery.productCode = barcode
#    Schema.products.findOne existedQuery