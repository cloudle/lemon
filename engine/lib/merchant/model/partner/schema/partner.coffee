simpleSchema.partners = new SimpleSchema
  parentMerchant:
    type: String

  creator:
    type: String

  name:
    type: String

  phone:
    type: String
    optional: true

  address:
    type: String
    optional: true

  avatar:
    type: String
    optional: true

  description:
    type: String
    optional: true

  buildIn:
    type: String
    optional: true

  merchantType:
    type: String
    defaultValue: 'myMerchant'

  importProductList:
    type: [String]
    optional: true

  status:
    type: String
    defaultValue: 'brandNew'

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }

#-------------------------------------------------------------------
  salePaid:
    type: Number
    defaultValue: 0

  saleDebt:
    type: Number
    defaultValue: 0

  saleTotalCash:
    type: Number
    defaultValue: 0

  importPaid:
    type: Number
    defaultValue: 0

  importDebt:
    type: Number
    defaultValue: 0

  importTotalCash:
    type: Number
    defaultValue: 0

#-------------------------------------------------------------------
  importList:
    type: [String]
    defaultValue: []

  productDetailList:
    type: [String]
    defaultValue: []

  productList:
    type: [String]
    defaultValue: []

  branchProductList:
    type: [String]
    defaultValue: []

  productUnitList:
    type: [String]
    defaultValue: []

  branchProductUnitList:
    type: [String]
    defaultValue: []


  buildInProductList:
    type: [String]
    defaultValue: []
  buildInProductUnitList:
    type: [String]
    defaultValue: []
#-------------------------------------------------------------------


