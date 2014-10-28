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

  tabDisplay:
    type: String
    defaultValue: 'New Order'
    optional: true

  orderCode:
    type: String
    optional: true

  productCount:
    type: Number
    defaultValue: 0
    optional: true

  saleCount:
    type: Number
    defaultValue: 0
    optional: true

  paymentsDelivery:
    type: Number
    defaultValue: 0
    optional: true

  paymentMethod:
    type: Number
    defaultValue: 0
    optional: true

  billDiscount:
    type: Boolean
    defaultValue: false
    optional: true

  discountCash:
    type: Number
    defaultValue: 0
    optional: true

  discountPercent:
    type: Number
    decimal: true
    defaultValue: 0
    optional: true

  totalPrice:
    type: Number
    defaultValue: 0
    optional: true

  finalPrice:
    type: Number
    defaultValue: 0
    optional: true

  deposit:
    type: Number
    defaultValue: 0
    optional: true

  debit:
    type: Number
    defaultValue: 0
    optional: true

  status:
    type: Number
    defaultValue: 0
    optional: true

  delivery:
    type: String
    optional: true

#  version: { type: Schema.Version }

#----------------------
  currentProduct:
    type: String
    defaultValue: "null"
    optional: true

  currentQuality:
    type: Number
    defaultValue: 0
    optional: true

  currentPrice:
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