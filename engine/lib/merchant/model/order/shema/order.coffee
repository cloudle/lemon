simpleSchema.orders = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String
    optional: true

  seller:
    type: String
    optional: true

  buyer:
    type: String
    optional: true

  description:
    type: String
    optional: true

  tabDisplay:
    type: String
    defaultValue: 'New Order'

  orderCode:
    type: String
    optional: true

  productCount:
    type: Number
    defaultValue: 0

  saleCount:
    type: Number
    defaultValue: 0

  paymentsDelivery:
    type: Number
    defaultValue: 0

  paymentMethod:
    type: Number
    defaultValue: 1

  billDiscount:
    type: Boolean
    defaultValue: false

  discountCash:
    type: Number
    defaultValue: 0

  discountPercent:
    type: Number
    decimal: true
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

  debit:
    type: Number
    defaultValue: 0

  status:
    type: Number
    defaultValue: 0

  delivery:
    type: String
    optional: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

#----------------------
  currentProduct:
    type: String
    defaultValue: "null"

  currentUnit:
    type: String
    optional: true

  currentQuality:
    type: Number
    defaultValue: 0
    optional: true

  currentPrice:
    type: Number
    defaultValue: 0
    optional: true

  currentTotalPrice:
    type: Number
    defaultValue: 0
    optional: true

  currentDiscountCash:
    type: Number
    defaultValue: 0
    optional: true

  currentDiscountPercent:
    type: Number
    decimal: true
    defaultValue: 0
    optional: true

  currentDeposit:
    type: Number
    defaultValue: 0
    optional: true
#----------------------
  contactName:
    type: String
    optional: true

  contactPhone:
    type: String
    optional: true

  deliveryAddress:
    type: String
    optional: true

  deliveryDate:
    type: Date
    optional: true

  comment:
    type: String
    optional: true
#----------------------