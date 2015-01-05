simpleSchema.customImports = new SimpleSchema
  parentMerchant:
    type: String

  creator:
    type: String

  seller:
    type: String

  customImportCode:
    type: String
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  description:
    type: String
    optional: true

  debtDate:
    type: Date

  latestDebtBalance:
    type: Number
    defaultValue: 0

  debtBalanceChange:
    type: Number
    defaultValue: 0

  beforeDebtBalance:
    type: Number
    defaultValue: 0

  version: { type: simpleSchema.Version }

