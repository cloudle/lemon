simpleSchema.skulls = new SimpleSchema
  parentMerchant:
    type: String

  merchant:
    type: String

  creator:
    type: String

  name:
    type: String

  value:
    type: String
    optional: true

  version: { type: Schema.Version }