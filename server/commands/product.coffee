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






#  insertProductAndRandomBarcode: (existedQuery, product)->
#    barcode = (Math.floor(Math.random() * 100000000000) + 89 *100000000000).toString()
#    existedQuery.productCode = barcode
#    Schema.products.findOne existedQuery