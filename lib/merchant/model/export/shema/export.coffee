simpleSchema.exports = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  merchant:
    type: String

  warehouse:
    type: String

  targetWarehouse:
    type: String

  creator:
    type: String

  name:
    type: String

  description:
    type: String

  success:
    type: Boolean

  status:
    type: Number

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }
