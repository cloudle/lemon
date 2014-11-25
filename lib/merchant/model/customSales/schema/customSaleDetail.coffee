simpleSchema.customSaleDetails = new SimpleSchema
  parentMerchant:
    type: String

  creator:
    type: String

  buyer:
    type: String

  customSale:
    type: String

  price:
    type: Number

  quality:
    type: Number

  totalPrice:
    type: Number

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

