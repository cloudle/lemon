simpleSchema.returnDetails  = new SimpleSchema
  sale:
    type: String
    optional: true

  saleDetail:
    type: String
    optional: true

  import:
    type: String
    optional: true
#----------------------------
  return:
    type: String

  product:
    type: String

  branchProduct:
    type: String

  productDetail:
    type: [Object]
    blackbox: true
    optional: true

  unit:
    type: String
    optional: true

  unitReturnQuality:
    type: Number
    optional: true

  unitReturnsPrice:
    type: Number
    optional: true

  conversionQuality:
    type: Number
    optional: true

  returnQuality:
    type: Number

  price:
    type: Number
    decimal: true

  discountCash:
    type: Number
    defaultValue: 0

  discountPercent:
    type: Number
    decimal: true
    defaultValue: 0

  totalPrice:
    type: Number
    optional: true

  finalPrice:
    type: Number

  submit:
    type: Boolean
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    optional: true

  version: { type: simpleSchema.Version }
#--------------------------------------------------
  name:
    type: String
    optional: true

  skulls:
    type: [String]
    optional: true

  color:
    type: String
    optional: true



