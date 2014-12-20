simpleSchema.returns = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  returnCode:
    type: String

  discountCash:
    type: Number

  discountPercent:
    type: Number
    decimal: true

  totalPrice:
    type: Number

  finallyPrice:
    type: Number

  comment:
    type: String

  status:
    type: Number

  submitReturn:
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
#------------------------
  sale:
    type: String
    optional: true

  timeLineSales:
    type: String
    optional: true

  customer:
    type: String
    optional: true
#------------------------
  import:
    type: String
    optional: true

  timeLineImport:
    type: String
    optional: true

  distributor:
    type: String
    optional: true
#------------------------
  beforeDebtBalance:
    type: Number
    optional: true

  debtBalanceChange:
    type: Number
    optional: true

  latestDebtBalance:
    type: Number
    optional: true
#------------------------
  creatorName:
    type: String
    optional: true

  productSale:
    type: Number
    optional: true

  productQuality:
    type: Number
    optional: true
