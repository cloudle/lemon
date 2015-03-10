simpleSchema.customers = new SimpleSchema
  parentMerchant:
    type: String

  currentMerchant:
    type: String

  merchant:
    type: String

  creator:
    type: String

  avatar:
    type: String
    optional: true

  areaMerchant:
    type: String
    optional: true

  areas:
    type: [String]
    optional: true

  builtIn:
    type: [String]
    optional: true

  saleProductList:
    type: [Object]
    optional: true
    blackbox: true

  name:
    type: String

  pronoun:
    type: String
    optional: true

  companyName:
    type: String
    optional: true

  phone:
    type: String
    optional: true

  address:
    type: String
    optional: true

  email:
    type: String
    optional: true

  dateOfBirth:
    type: Date
    optional: true

  gender:
    type: Boolean
    optional: true

  description:
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
#----------------------------------------------
  totalDebit:
    type: Number
    defaultValue: 0

  totalPurchases:
    type: Number
    defaultValue: 0

  lastSales:
    type: String
    optional: true

  debtBalance:
    type: Number
    defaultValue: 0

#----------------------------------------------
  totalCustomSaleDeposit:
    type: Number
    defaultValue: 0

  totalCustomSalePurchases:
    type: Number
    defaultValue: 0

  depositCash:
    type: Number
    defaultValue: 0
#----------------------------------------------
  customSalePaid:
    type: Number
    defaultValue: 0

  customSaleDebt:
    type: Number
    defaultValue: 0

  customSaleTotalCash:
    type: Number
    defaultValue: 0

  salePaid:
    type: Number
    defaultValue: 0

  saleDebt:
    type: Number
    defaultValue: 0

  saleTotalCash:
    type: Number
    defaultValue: 0
#------------------------------------------------
  customSaleModeEnabled:
    type: Boolean
    defaultValue: true

  billNo:
    type: String
    optional: true