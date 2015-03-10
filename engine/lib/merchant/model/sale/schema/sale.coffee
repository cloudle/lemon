simpleSchema.sales = new SimpleSchema
  parentMerchant:
    type: String

  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  seller:
    type: String

  buyer:
    type: String

  orderCode:
    type: String

  productCount:
    type: Number
    defaultValue: 0

  saleCount:
    type: Number
    defaultValue: 0

  return:
    type: Boolean
    optional: true

  returnLock:
    type: Boolean
    optional: true

  returnCount:
    type: Number
    defaultValue: 0

  returnQuality:
    type: Number
    defaultValue: 0

  delivery:
    type: String
    optional: true

  paymentMethod:
    type: Number
    defaultValue: 0

  billDiscount:
    type: Boolean
    defaultValue: false

  discountCash:
    type: Number
    defaultValue: 0

  totalPrice:
    type: Number
    defaultValue: 0

  finalPrice:
    type: Number
    defaultValue: 0

  deposit:
    type: Number
    defaultValue: 0

  soldAt:
    type: Date
    optional: true

  description:
    type: String
    optional: true

  latestDebtBalance:
    type: Number
    defaultValue: 0

  debtBalanceChange:
    type: Number
    defaultValue: 0

  beforeDebtBalance:
    type: Number
    defaultValue: 0

  debit:
    type: Number
    defaultValue: 0

  paymentsDelivery:
    type: Number
    defaultValue: 0

  #người xác nhận đã nhận tiền
  recipient:
    type: String
    optional: true

  received:
    type: Boolean
    defaultValue: false

  imported:
    type: Boolean
    defaultValue: false

  exported:
    type: Boolean
    defaultValue: false

  status:
    type: Boolean
    defaultValue: false

  success:
    type: Boolean
    optional: true

  submitted:
    type: Boolean
    defaultValue: false

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }
#----------------------------------------
  currentReturn:
    type: String
    optional: true

  currentProductDetail:
    type: String
    optional: true

  currentQuality:
    type: Number
    optional: true




