simpleSchema.saleDetails = new SimpleSchema
  sale:
    type: String

  product:
    type: String

  branchProduct:
    type: String

  productDetail:
    type: String
    optional: true

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
    decimal: true

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

  totalCogs:
    type: Number
    optional: true

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