Schema.add 'saleExports', "SaleExport", class SaleExport
  @new: (sale ,saleDetail)->
    option =
      merchant      : sale.merchant
      warehouse     : sale.warehouse
      creator       : Meteor.userId()
      sale          : sale._id
      product       : saleDetail.product
      qualityExport : saleDetail.quality
      unitQuality       : saleDetail.unitQuality
      unitPrice         : saleDetail.unitPrice
      conversionQuality : saleDetail.conversionQuality

    option.unit   = saleDetail.unit if saleDetail.unit
    option.skulls = saleDetail.skulls if saleDetail.skulls
    option.productDetail = saleDetail.productDetail if saleDetail.productDetail
    option







