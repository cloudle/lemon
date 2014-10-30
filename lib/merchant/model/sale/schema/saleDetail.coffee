simpleSchema.saleDetails = new SimpleSchema
  sale:
    type: String

  product:
    type: String

  productDetail:
    type: String

  color:
    type: String
    optional: true

  quality:
    type: Number

  returnQuality:
    type: Number
    optional: true

  price:
    type: Number

  discountCash:
    type: Number
    decimal: true

  discountPercent:
    type: Number
    decimal: true

  finalPrice:
    type: Number

  styles:
    type: String
    optional: true

  export:
    type: Boolean

  exportDate:
    type: Date
    optional: true

  status:
    type: Boolean

  version: { type: simpleSchema.Version }

