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

  skulls:
    type: [String]

  childProduct:
    type: Schema.ChildProduct
    optional: true

  alertQuality:
    type: Number
    min: 0
    defaultValue: 0

  totalQuality:
    type: Number
    min: 0
    defaultValue: 0

  availableQuality:
    type: Number
    min: 0
    defaultValue: 0

  inStockQuality:
    type: Number
    min: 0
    defaultValue: 0

  upperGapQuality:
    type: Number
    optional: true

  price:
    type: Number
    min: 0
    defaultValue: 0

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

  provider:
    type: String
    optional: true

  importPrice:
    type: Number
    optional: true

