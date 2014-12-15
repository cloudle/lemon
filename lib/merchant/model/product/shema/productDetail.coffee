simpleSchema.productDetails = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  import:
    type: String
    optional: true

  provider:
    type: String
    optional: true

  distributor:
    type: String
    optional: true

  product:
    type: String

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

  importQuality:
    type: Number

  availableQuality:
    type: Number
    min: 0

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
    optional: true

  inventory:
    type: String
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  version: { type: simpleSchema.Version }
