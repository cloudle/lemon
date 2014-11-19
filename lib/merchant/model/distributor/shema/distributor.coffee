simpleSchema.distributors = new SimpleSchema
  parentMerchant:
    type: String

  merchant:
    type: String

  creator:
    type: String

  name:
    type: String

  representative:
    type: String
    optional: true

  phone:
    type: String
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  status:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  location: { type: simpleSchema.Location, optional: true }
  version: { type: simpleSchema.Version }
