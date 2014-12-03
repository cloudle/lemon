simpleSchema.customImportDetails = new SimpleSchema
  parentMerchant:
    type: String

  creator:
    type: String

  seller:
    type: String

  customImport:
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

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }

