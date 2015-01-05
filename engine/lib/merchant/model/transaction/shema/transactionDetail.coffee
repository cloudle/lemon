simpleSchema.transactionDetails = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  transaction:
    type: String

  totalCash:
    type: Number

  depositCash:
    type: Number

  debitCash:
    type: Number

  description:
    type: String
    optional: true

  paymentDate:
    type: Date
    defaultValue: new Date()

  version: {type: simpleSchema.Version}
