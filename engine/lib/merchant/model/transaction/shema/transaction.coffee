simpleSchema.transactions = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  merchant:
    type: String
    optional: true

  warehouse:
    type: String
    optional: true

  parent:
    type: String
    optional: true

  parentTransaction:
    type: String
    optional: true

  creator:
    type: String
    optional: true

  owner:
    type: String
    optional: true

  group:
    type: String

  receivable:
    type: Boolean

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: {type: simpleSchema.Version}
#---------------------------------------------
  description:
    type: String
    optional: true

  debtBalanceChange:
    type: Number
    optional: true

  latestSale:
    type: String
    optional: true

  latestImport:
    type: String
    optional: true

  beforeDebtBalance:
    type: Number
    optional: true

  latestDebtBalance:
    type: Number
    optional: true

  debtDate:
    type: Date
    defaultValue: new Date()

  confirmed:
    type: Boolean
    defaultValue: false

  conformer:
    type: String
    optional: true

  conformedAt:
    type: Date
    optional: true

#---------------------------------------------
  totalCash:
    type: Number
    optional: true

  dueDay:
    type: Date
    optional: true

  status:
    type: String
    defaultValue: 'success'

  depositCash:
    type: Number
    optional: true

  debitCash:
    type: Number
    optional: true

