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
#-----------------------------------------------
# name, image, groups, importPrice
  hasOverride:
    type: [String]
    optional: true

  buildInProduct:
    type: String
    optional: true

  branchList:
    type: [String]
    defaultValue: []

  price:
    type: Number
    optional: true
    defaultValue: 0

  importPrice:
    type: Number
    optional: true
    defaultValue: 0

  alertQuality:
    type: Number
    defaultValue: 0

  upperGapQuality:
    type: Number
    optional: true
#-----------------------------------------------
  creator:
    type: String
    optional: true

  createMerchant:
    type: String
    optional: true

  parentMerchant:
    type: String
    optional: true

  merchant:
    type: String

  warehouse:
    type: String

  basicDetailModeEnabled:
    type: Boolean
    defaultValue: true

  allowDelete:
    type: Boolean
    defaultValue: true

  status:
    type: String
    defaultValue: 'brandNew'

  salesQuality:
    type: Number
    defaultValue: 0

  returnQualityByCustomer:
    type: Number
    defaultValue: 0

  returnQualityByDistributor:
    type: Number
    defaultValue: 0

  totalQuality:
    type: Number
    defaultValue: 0

  availableQuality:
    type: Number
    defaultValue: 0

  inStockQuality:
    type: Number
    defaultValue: 0

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }

#-----------------------------------------------
  provider:
    type: String
    optional: true

  avatar:
    type: String
    optional: true

  childProduct:
    type: Schema.ChildProduct
    optional: true