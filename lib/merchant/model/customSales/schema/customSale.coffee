simpleSchema.customSales = new SimpleSchema
  parentMerchant:
    type: String

  creator:
    type: String

  buyer:
    type: String

  orderCode:
    type: String
    optional: true

  totalPrice:
    type: Number

  finalPrice:
    type: Number

  deposit:
    type: Number

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

