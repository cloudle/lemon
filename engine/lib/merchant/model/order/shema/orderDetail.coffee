simpleSchema.orderDetails = new SimpleSchema
  order:
    type: String

  product:
    type: String

  branchProduct:
    type: String

  quality:
    type: Number

  price:
    type: Number
    decimal: true

  discountCash:
    type: Number

  discountPercent:
    type: Number
    decimal: true

  tempDiscountPercent:
    type: Number
    decimal: true
    optional: true

  totalPrice:
    type: Number

  finalPrice:
    type: Number

  styles:
    type: String
    optional: true

  color:
    type: String
    optional: true

  version: { type: simpleSchema.Version }

  unit:
    type: String
    optional: true

  unitQuality:
    type: Number
    optional: true

  unitPrice:
    type: Number
    optional: true

  conversionQuality:
    type: Number
    optional: true

  inValid:
    type: Boolean
    optional: true

