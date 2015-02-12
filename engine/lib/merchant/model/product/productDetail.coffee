Schema.add 'productDetails', "ProductDetail", class ProductDetail
  @newProductDetail: (imports, importDetail)->
    option =
      import           : imports._id
      parentMerchant   : imports.parentMerchant
      merchant         : imports.merchant
      warehouse        : imports.warehouse
      product          : importDetail.product
      branchProduct    : importDetail.branchProduct
      importQuality    : importDetail.importQuality
      availableQuality : importDetail.importQuality
      inStockQuality   : importDetail.importQuality
      importPrice      : importDetail.importPrice
      checkingInventory: false
      unitQuality      : importDetail.unitQuality
      unitPrice        : importDetail.unitPrice
      conversionQuality: importDetail.conversionQuality

    option.unit                = importDetail.unit if importDetail.unit
    option.branchUnit          = importDetail.branchUnit if importDetail.branchUnit
    option.buildInProduct      = importDetail.buildInProduct if importDetail.buildInProduct
    option.buildInProductUnit  = importDetail.buildInProductUnit if importDetail.buildInProductUnit

    option.distributor = imports.distributor if imports.distributor
    option.partner     = imports.partner if imports.partner
    option.provider    = importDetail.provider if importDetail.provider
    option.expire      = importDetail.expire if importDetail.expire
    option




