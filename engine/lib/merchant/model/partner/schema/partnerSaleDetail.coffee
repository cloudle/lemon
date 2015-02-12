simpleSchema.partnerSaleDetails = new SimpleSchema
  buildInProduct:
    type: String

  product:
    type: String
    optional: true

  quality:
    type: Number

  price:
    type: Number
    decimal: true
#----------------------------------------
  buildInProductUnit:
    type: String
    optional: true

  unit:
    type: String
    optional: true

  unitQuality:
    type: Number
    optional: true
    decimal: true

  unitPrice:
    type: Number
    optional: true

  conversionQuality:
    type: Number
    optional: true
#----------------------------------------

  partnerSales:
    type: String

  branchProduct:
    type: String
    optional: true

  productDetail:
    type: String
    optional: true

  returnQuality:
    type: Number
    optional: true

  discountCash:
    type: Number
    decimal: true

  discountPercent:
    type: Number
    decimal: true

  totalPrice:
    type: Number

  finalPrice:
    type: Number
    decimal: true

  export:
    type: Boolean

  exportDate:
    type: Date
    optional: true

  status:
    type: Boolean

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }

Schema.add 'partnerSaleDetails', "PartnerSaleDetails", class PartnerSaleDetails
  @findBy: (importId, warehouseId = null, merchantId = null)->


