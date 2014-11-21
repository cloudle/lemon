Schema.add 'merchants', "Merchant", class Merchant
#  checkProductExpireDate: (value, merchantId)->
#    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
#      timeOneDay = 86400000
#      tempDate = new Date
#      currentDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
#      expireDate  = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate() + value)
#
#      productDetails = Schema.productDetails.find({$and:[
#          {merchant: merchantId}
#          {expire:{$lte: expireDate}}
#          {inStockQuality:{$gt: 0}}
#        ]}).fetch()
#
#      for productDetail in productDetails
#        product   = Schema.products.findOne(productDetail.product)
#        warehouse = Schema.warehouses.findOne(productDetail.warehouse)
#        date      = ((productDetail.expire).getTime() - currentDate.getTime())/timeOneDay
#
#        currentProduct = {
#          _id   : productDetail._id
#          name  : product.name
#          day   : date
#          place : warehouse.name }
#        Notification.productExpire(currentProduct)

  addDefaultWarehouse: ->
    if Schema.warehouse.findOne({merchant: @id})
      option =
        merchant          : @id
        creator           : Meteor.userId()
        name              : 'Kho Chính'
        isRoot            : true
        checkingInventory : false
      option.parentMerchant = merchant.parent if merchant.parent
      option





