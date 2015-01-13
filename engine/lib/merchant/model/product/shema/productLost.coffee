simpleSchema.productLosts = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  product:
    type: String

  productDetail:
    type: String

  inventory:
    type: String

  lostQuality:
    type: Number

  version: { type: simpleSchema.Version }

