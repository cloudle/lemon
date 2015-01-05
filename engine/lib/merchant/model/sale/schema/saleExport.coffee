simpleSchema.saleExports = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  sale:
    type: String

  product:
    type: String

  productDetail:
    type: String
    optional: true

  name:
    type: String
    optional: true

  skulls:
    type: [String]
    optional: true

  qualityExport:
    type: Number

  styles:
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

