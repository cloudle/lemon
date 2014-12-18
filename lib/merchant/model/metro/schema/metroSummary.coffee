simpleSchema.metroSummaries = new SimpleSchema
  parentMerchant:
    type: String

  merchant:
    type: String

  merchantCount:
    type: Number
    defaultValue: 1

  warehouseCount:
    type: Number
    defaultValue: 1

  warehouseCountAll:
    type: Number
    defaultValue: 1

  customerCountAll:
    type: Number
    defaultValue: 0

  customerCount:
    type: Number
    defaultValue: 0

  distributorCount:
    type: Number
    defaultValue: 0

  staffCountAll:
    type: Number
    defaultValue: 1

  staffCount:
    type: Number
    defaultValue: 0

  productCount:
    type: Number
    defaultValue: 0

  stockProductCount:
    type: Number
    defaultValue: 0

  availableProductCount:
    type: Number
    defaultValue: 0

  importCount:
    type: Number
    defaultValue: 0

  importProductCount:
    type: Number
    defaultValue: 0

  saleCount:
    type: Number
    defaultValue: 0

  saleProductCount:
    type: Number
    defaultValue: 0

  deliveryCount:
    type: Number
    defaultValue: 0

  deliveryProductCount:
    type: Number
    defaultValue: 0

  returnCount:
    type: Number
    defaultValue: 0

  returnProductCount:
    type: Number
    defaultValue: 0

  inventoryCount:
    type: Number
    defaultValue: 0

  inventoryProductCount:
    type: Number
    defaultValue: 0

  returnCash:
    type: Number
    defaultValue: 0

  saleDiscountCash:
    type: Number
    defaultValue: 0

  saleDepositCash:
    type: Number
    defaultValue: 0

  saleDebitCash:
    type: Number
    defaultValue: 0

  saleRevenueCash:
    type: Number
    defaultValue: 0

  importDepositCash:
    type: Number
    defaultValue: 0

  importDebitCash:
    type: Number
    defaultValue: 0

  importRevenueCash:
    type: Number
    defaultValue: 0

  version: { type: simpleSchema.Version }
#------------------------------------------
  totalReceivableCash:
    type: Number
    defaultValue: 0

  totalPayableCash:
    type: Number
    defaultValue: 0
#------------------------------------------

  discountDay:
    type: Number
    defaultValue: 0

  depositDay:
    type: Number
    defaultValue: 0

  debitDay:
    type: Number
    defaultValue: 0
  #doanh thu
  revenueDay:
    type: Number
    defaultValue: 0
  #tien von
  cogsDay:
    type: Number
    defaultValue: 0
  #loi nhuan
  profitabilityDay:
    type: Number
    defaultValue: 0

#------------------------------------------
  notifyExpire:
    type: Boolean
    defaultValue: false

