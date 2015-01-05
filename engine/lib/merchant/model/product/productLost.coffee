Schema.add 'productLosts', "ProductLost", class ProductLost
  @new: (warehouse, inventoryDetail)->
    option =
      merchant      : warehouse.merchant
      warehouse     : warehouse._id
      creator       : Meteor.userId()
      product       : inventoryDetail.product
      productDetail : inventoryDetail.productDetail
      inventory     : inventoryDetail.inventory
      lostQuality   : inventoryDetail.lostQuality