simpleSchema.products = new SimpleSchema
  name:
    type: String
    optional: true

  image:
    type: String
    optional: true

  productCode:
    type: String
    optional: true

  basicUnit:
    type: String
    optional: true

  skulls:
    type: [String]
    optional: true

  groups:
    type: [String]
    optional: true

  description:
    type: String
    optional: true

  price:
    type: Number
    optional: true

  importPrice:
    type: Number
    optional: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }
#-----------------------------------------------
  parentMerchant:
    type: String
    optional: true

  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  buildIn:
    type: Boolean
    defaultValue: true

  buildInProduct:
    type: String
    optional: true

  basicDetailModeEnabled:
    type: Boolean
    defaultValue: true

  provider:
    type: String
    optional: true

  alertQuality:
    type: Number
    defaultValue: 0

  upperGapQuality:
    type: Number
    optional: true

  expireDate:
    type: Date
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true
#-----------------------------------------------

  childProduct:
    type: Schema.ChildProduct
    optional: true

  salesQuality:
    type: Number
    defaultValue: 0
    optional: true

  returnQualityByCustomer:
    type: Number
    defaultValue: 0
    optional: true

  returnQualityByDistributor:
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

  avatar:
    type: String
    optional: true
