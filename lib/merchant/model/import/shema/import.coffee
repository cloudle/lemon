simpleSchema.imports = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  distributor:
    type: String
    optional: true

  description:
    type: String

  totalPrice:
    type: Number
    defaultValue: 0

  deposit:
    type: Number
    defaultValue: 0

  debit:
    type: Number
    defaultValue: 0

  finish:
    type: Boolean
    defaultValue: false

  submitted:
    type: Boolean
    defaultValue: false

  systemTransaction:
    type: String
    optional: true

  status:
    type: String
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

#----------------------------------
  latestDebtBalance:
    type: Number
    defaultValue: 0

  debtBalanceChange:
    type: Number
    defaultValue: 0

  beforeDebtBalance:
    type: Number
    defaultValue: 0
#----------------------------------
  currentProduct:
    type: String
    optional: true

  currentProvider:
    type: String
    optional: true

  currentQuality:
    type: Number
    optional: true

  currentImportPrice:
    type: Number
    optional: true

  currentPrice:
    type: Number
    optional: true

  currentExpire:
    type: Date
    optional: true
