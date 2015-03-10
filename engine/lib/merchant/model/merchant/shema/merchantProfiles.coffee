simpleSchema.merchantProfiles = new SimpleSchema
  merchantRegistered:
    type: Boolean

  user:
    type: String

  merchant:
    type: String
    optional: true

  packageClassActive:
    type: Boolean
    defaultValue: false

  trialEndDate:
    type: Date
    optional: true

  activeEndDate:
    type: Date
    optional: true

  packageClass:
    type: String
    defaultValue: 'free'

  price:
    type: Number
    defaultValue: 0

  duration:
    type: Number
    defaultValue: 14

  defaultAccountLimit:
    type: Number
    defaultValue: 5

  defaultBranchLimit:
    type: Number
    defaultValue: 1

  defaultWarehouseLimit:
    type: Number
    defaultValue: 1

  extendAccountLimit:
    type: Number
    defaultValue: 0

  extendBranchLimit:
    type: Number
    defaultValue: 0

  extendWarehouseLimit:
    type: Number
    defaultValue: 0

  extendAccountPrice:
    type: Number
    defaultValue: 0

  extendBranchPrice:
    type: Number
    defaultValue: 0

  extendWarehousePrice:
    type: Number
    defaultValue: 0

  totalPrice:
    type: Number
    defaultValue: 0

  version: { type: simpleSchema.Version }

#-------------------------------------------------------
  merchantList:
    type: [String]
    defaultValue: []

  warehouseList:
    type: [String]
    defaultValue: []

  staffList:
    type: [String]
    defaultValue: []

  customerList:
    type: [String]
    defaultValue: []

  distributorList:
    type: [String]
    defaultValue: []

  partnerList:
    type: [String]
    defaultValue: []

  merchantPartnerList:
    type: [String]
    defaultValue: []

  productList:
    type: [String]
    defaultValue: []

  geraProductList:
    type: [String]
    defaultValue: []
#-------------------------------------------------------

  companyName:
    type: String
    optional: true

  contactPhone:
    type: String
    optional: true

  contactAddress:
    type: String
    optional: true

  merchantName:
    type: String
    optional: true

  warehouseName:
    type: String
    optional: true

Schema.add 'merchantProfiles'