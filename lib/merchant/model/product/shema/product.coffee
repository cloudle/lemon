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

  upperGapQuality:
    type: Number
    optional: true

  price:
    type: Number
    defaultValue: 0

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

