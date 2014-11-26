simpleSchema.customers = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  currentMerchant:
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

  totalSaleDeposit:
    type: Number
    defaultValue: 0

  totalSalePurchases:
    type: Number
    defaultValue: 0
#----------------------------------------------
  totalCustomSaleDeposit:
    type: Number
    defaultValue: 0

  totalCustomSalePurchases:
    type: Number
    defaultValue: 0