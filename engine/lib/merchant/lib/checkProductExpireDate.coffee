Apps.Merchant.checkProductExpireDate = (profile, value)->
  if profile
    timeOneDay  = 86400000
    tempDate    = new Date
    currentDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
    expireDate  = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate() + value)

    allWarehouse = Schema.warehouses.find({parentMerchant: profile.parentMerchant}).fetch()
    productDetails = Schema.productDetails.find({$and:[
      {warehouse: {$in:_.pluck(allWarehouse, '_id')}}
      {expire:{$lte: expireDate}}
      {inStockQuality:{$gt: 0}}
    ]}).fetch()

    Schema.expiringProducts.remove({merchant: {$in: _.union(_.pluck(productDetails, 'merchant'))}})

    for productDetail in productDetails
      product   = Schema.products.findOne(productDetail.product)
      warehouse = _.findWhere(allWarehouse, {_id: productDetail.warehouse})
      date      = ((productDetail.expire).getTime() - currentDate.getTime())/timeOneDay

      currentProduct = {
        _id   : productDetail._id
        name  : product.name
        day   : date
        place : warehouse.name }
      Notification.productExpire(currentProduct, profile)

      expiringProduct =
        merchant      : productDetail.merchant
        productDetail : productDetail._id
        expireDate    : productDetail.expire
      Schema.expiringProducts.insert(expiringProduct)

    Schema.branchProfiles.update({merchant: profile.parentMerchant}, {$set:{latestCheckExpire: new Date()}})

    for merchantId in _.union(_.pluck(productDetails, 'merchant'))
      if Schema.expiringProducts.findOne({merchant: merchantId})
        Schema.branchProfiles.update({merchant: merchantId}, {$set:{hasExpiringProduct: true}})
      else
        Schema.branchProfiles.update({merchant: merchantId}, {$set:{hasExpiringProduct: false}})