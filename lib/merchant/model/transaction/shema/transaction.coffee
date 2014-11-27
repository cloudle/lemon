simpleSchema.transactions = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  parent:
    type: String
    optional: true

  creator:
    type: String

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

  latestSale:
    type: String
    optional: true

  beforeDebtBalance:
    type: Number

  latestDebtBalance:
    type: Number

  debtDate:
    type: Date
    defaultValue: new Date()

#---------------------------------------------
  totalCash:
    type: Number
    optional: true

  dueDay:
    type: Date
    optional: true

  status:
    type: String
    optional: true

  depositCash:
    type: Number
    optional: true

  debitCash:
    type: Number
    optional: true

