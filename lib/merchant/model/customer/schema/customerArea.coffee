simpleSchema.customerAreas = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  creator:
    type: String

  name:
    type: String

  description:
    type: String
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }


