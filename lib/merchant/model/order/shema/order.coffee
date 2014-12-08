simpleSchema.orders = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

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
    defaultValue: 0

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

  currentQuality:
    type: Number
    defaultValue: 0

  currentPrice:
    type: Number
    defaultValue: 0

  currentTotalPrice:
    type: Number
    defaultValue: 0

  currentDiscountCash:
    type: Number
    defaultValue: 0

  currentDiscountPercent:
    type: Number
    decimal: true
    defaultValue: 0

  currentDeposit:
    type: Number
    defaultValue: 0
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