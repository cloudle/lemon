simpleSchema.customSales = new SimpleSchema
  parentMerchant:
    type: String

  creator:
    type: String

  buyer:
    type: String

  customSaleCode:
    type: String
    optional: true

  debtDate:
    type: Date

  description:
    type: String

  totalCash:
    type: Number
    defaultValue: 0

  depositCash:
    type: Number
    defaultValue: 0

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }

