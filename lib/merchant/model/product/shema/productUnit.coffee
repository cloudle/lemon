simpleSchema.productUnits = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  product:
    type: String

  productCode:
    type: String
    optional: true

  unit:
    type: String

  conversionQuality:
    type: Number

  price:
    type: Number

  version: { type: simpleSchema.Version }
