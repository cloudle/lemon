simpleSchema.products = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  name:
    type: String

  image:
    type: String
    optional: true

  groups:
    type: [String]
    optional: true

  productCode:
    type: String
    optional: true

  skulls:
    type: [String]
    optional: true

  basicUnit:
    type: String
    optional: true

  childProduct:
    type: Schema.ChildProduct
    optional: true

  alertQuality:
    type: Number
    defaultValue: 0

  salesQuality:
    type: Number
    defaultValue: 0
    optional: true

  totalQuality:
    type: Number
    defaultValue: 0

  availableQuality:
    type: Number
    defaultValue: 0

  inStockQuality:
    type: Number
    defaultValue: 0

  upperGapQuality:
    type: Number
    optional: true

  price:
    type: Number
    defaultValue: 0

  allowDelete:
    type: Boolean
    defaultValue: true

  avatar:
    type: String
    optional: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  basicDetailModeEnabled:
    type: Boolean
    defaultValue: true

  version: { type: simpleSchema.Version }
#-----------------------------------------------
  provider:
    type: String
    optional: true

  importPrice:
    type: Number
    defaultValue: 0

