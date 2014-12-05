simpleSchema.productDetails = new SimpleSchema
  import:
    type: String

  merchant:
    type: String

  warehouse:
    type: String

  provider:
    type: String
    optional: true

  distributor:
    type: String
    optional: true

  product:
    type: String

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

  inventory:
    type: String
    optional: true

  version: { type: simpleSchema.Version }
