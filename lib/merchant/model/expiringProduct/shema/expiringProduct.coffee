simpleSchema.expiringProducts = new SimpleSchema
  merchant:
    type: String

  productDetail:
    type: String

  expireDate:
    type: Date

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }

