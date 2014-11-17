Schema.add 'productDetails', "ProductDetail", class ProductDetail
  @newProductDetail: (imports, importDetail)->
    option =
      import           : imports._id
      merchant         : imports.merchant
      warehouse        : imports.warehouse
      product          : importDetail.product
      provider         : importDetail.provider if importDetail.provider
      importQuality    : importDetail.importQuality
      availableQuality : importDetail.importQuality
      inStockQuality   : importDetail.importQuality
      importPrice      : importDetail.importPrice
      checkingInventory: false
    option.expire = importDetail.expire if importDetail.expire
    option




