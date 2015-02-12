simpleSchema.productDetails = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

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

  partner:
    type: String
    optional: true

  product:
    type: String

  branchProduct:
    type: String
    optional: true

  unit:
    type: String
    optional: true

  branchUnit:
    type: String
    optional: true

  buildInProduct:
    type: String
    optional: true

  buildInProductUnit:
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

  returnQualityByCustomer:
    type: Number
    defaultValue: 0
    optional: true

  returnQualityByDistributor:
    type: Number
    defaultValue: 0
    optional: true

  importPrice:
    type: Number
    min: 0
    decimal: true

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

  status:
    type: String
    defaultValue: 'new'

  version: { type: simpleSchema.Version }
