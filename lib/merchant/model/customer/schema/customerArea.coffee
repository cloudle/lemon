simpleSchema.customerArea = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  name:
    type: String

  description:
    type: Boolean
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }


