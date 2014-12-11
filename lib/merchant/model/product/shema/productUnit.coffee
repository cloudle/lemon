simpleSchema.productUnits = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  product:
    type: String

  unit:
    type: String

  quality:
    type: Number

  conversionQuality:
    type: Number

  price:
    type: Number

  import:
    type: String

  provider:
    type: String
    optional: true

  distributor:
    type: String
    optional: true

  inStockQuality:
    type: Number
    min: 0

  importPrice:
    type: Number
    min: 0

  expire:
    type: Date
    optional: true

  systemTransaction:
    type: String
    optional: true

  checkingInventory:
    type: Boolean

  inventory:
    type: String
    optional: true

  version: { type: simpleSchema.Version }
