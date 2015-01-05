Schema.add 'productDetails', "ProductDetail", class ProductDetail
  @newProductDetail: (imports, importDetail)->
    option =
      import           : imports._id
      merchant         : imports.merchant
      warehouse        : imports.warehouse
      product          : importDetail.product
      importQuality    : importDetail.importQuality
      availableQuality : importDetail.importQuality
      inStockQuality   : importDetail.importQuality
      importPrice      : importDetail.importPrice
      checkingInventory: false
      unitQuality      : importDetail.unitQuality
      unitPrice        : importDetail.unitPrice
      conversionQuality: importDetail.conversionQuality
    option.unit        = importDetail.unit if importDetail.unit

    option.distributor = imports.distributor if imports.distributor
    option.provider    = importDetail.provider if importDetail.provider
    option.expire      = importDetail.expire if importDetail.expire
    option



