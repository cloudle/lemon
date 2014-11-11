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

  dueDay:
    type: Date
    optional: true

  totalCash:
      type: Number

  depositCash:
    type: Number

  debitCash:
    type: Number

  status:
    type: String

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: {type: simpleSchema.Version}








