simpleSchema.sales = new SimpleSchema
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

  saleCount:
    type: Number

  return:
    type: Boolean
    optional: true

  returnLock:
    type: Boolean
    optional: true

  returnCount:
    type: Number

  returnQuality:
    type: Number

  delivery:
    type: String
    optional: true

  paymentMethod:
    type: Number

  billDiscount:
    type: Boolean

  discountCash:
    type: Number

  totalPrice:
    type: Number

  finalPrice:
    type: Number

  deposit:
    type: Number

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

  paymentsDelivery:
    type: Number

  #người xác nhận đã nhận tiền
  recipient:
    type: String
    optional: true

  received:
    type: Boolean

  imported:
    type: Boolean

  exported:
    type: Boolean

  status:
    type: Boolean

  success:
    type: Boolean
    optional: true

  submitted:
    type: Boolean

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




