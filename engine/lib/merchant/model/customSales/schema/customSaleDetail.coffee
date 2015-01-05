simpleSchema.customSaleDetails = new SimpleSchema
  parentMerchant:
    type: String

  creator:
    type: String

  buyer:
    type: String

  customSale:
    type: String

  productName:
    type: String

  skulls:
    type: String

  price:
    type: Number

  quality:
    type: Number

  finalPrice:
    type: Number

  pay:
    type: Boolean
    defaultValue: false

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

