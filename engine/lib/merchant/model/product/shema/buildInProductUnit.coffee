simpleSchema.buildInProductUnits = new SimpleSchema
  buildInProduct:
    type: String

  productCode:
    type: String

  image:
    type: String
    optional: true

  unit:
    type: String
    optional: true

  conversionQuality:
    type: Number
    min: 1
    defaultValue: 1

  creator:
    type: String

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }

