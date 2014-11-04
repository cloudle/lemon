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

  product:
    type: String

  importQuality:
    type: Number

  availableQuality:
    type: Number

  inStockQuality:
    type: Number

  importPrice:
    type: Number

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
