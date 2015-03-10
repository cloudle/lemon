simpleSchema.metroSummaries = new SimpleSchema
  parentMerchant:
    type: String

  merchant:
    type: String

  warehouseList:
    type: [String]
    defaultValue: []

  staffList:
    type: [String]
    defaultValue: []

  productList:
    type: [String]
    defaultValue: []

  geraProductList:
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

  version: { type: simpleSchema.Version }

#--------- Sale - Delivery - Import - Return - Inventory - Transfer ---------

  saleCount:
    type: Number
    defaultValue: 0

  saleDay:
    type: [String]
    defaultValue: []
  saleMonth:
    type: [String]
    defaultValue: []
#--------------------
  deliveryCount:
    type: Number
    defaultValue: 0

  deliveryWaiting:
    type: [String]
    defaultValue: []
  deliveryDay:
    type: [String]
    defaultValue: []
  deliveryMonth:
    type: [String]
    defaultValue: []

#---------------------
  importCount:
    type: Number
    defaultValue: 0

  importDay:
    type: [String]
    defaultValue: []
  importMonth:
    type: [String]
    defaultValue: []
#--------------------
  returnCount:
    type: Number
    defaultValue: 0

  returnCustomerDay:
    type: [String]
    defaultValue: []
  returnCustomerMonth:
    type: [String]
    defaultValue: []
  returnDistributorDay:
    type: [String]
    defaultValue: []
  returnDistributorMonth:
    type: [String]
    defaultValue: []
#--------------------
  inventoryCount:
    type: Number
    defaultValue: 0

  inventoryUnUpdateDay:
    type: Number
    defaultValue: 0

  inventoryDay:
    type: [String]
    defaultValue: []
  inventoryMonth:
    type: [String]
    defaultValue: []
#--------------------
  transferCount:
    type: Number
    defaultValue: 0
  transferDay:
    type: [String]
    defaultValue: []
  transferMonth:
    type: [String]
    defaultValue: []

#---------------------
  saleProductCount:
    type: Number
    defaultValue: 0
  deliveryProductCount:
    type: Number
    defaultValue: 0
  importProductCount:
    type: Number
    defaultValue: 0
  returnProductCount:
    type: Number
    defaultValue: 0
  inventoryProductCount:
    type: Number
    defaultValue: 0
#------------------------------------------


#---------Merchant - Staff - Product---------
  warehouseCount:
    type: Number
    defaultValue: 1

  staffCount:
    type: Number
    defaultValue: 0

  productCount:
    type: Number
    defaultValue: 0

  myProductCount:
    type: Number
    defaultValue: 0
#-----------------------------------------------------------------
#---------Customer - Distributor - Partner------------------------
  customerCount:
    type: Number
    defaultValue: 0

  distributorCount:
    type: Number
    defaultValue: 0

  partnerCount:
    type: Number
    defaultValue: 0
#-----------------------------------------------------------------

#------------------------------------------
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

#------------------------------------------
  notifyExpire:
    type: Boolean
    defaultValue: false

  totalReceivableCash:
    type: Number
    defaultValue: 0

  totalPayableCash:
    type: Number
    defaultValue: 0

  #loi nhuan ngay
  profitabilityDay:
    type: Number
    defaultValue: 0
  #tien ban hang cua hom nay
  salesMoneyDay:
    type: Number
    defaultValue: 0
  #tien nhap hang cua hom nay
  importMoneyDay:
    type: Number
    defaultValue: 0
  #tien tra hang (khach hang) cua hom nay
  returnMoneyOfDistributorDay:
    type: Number
    defaultValue: 0
  #tien ban hang (nha cung cap) cua hom nay
  returnMoneyOfCustomerDay:
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

#------------------------------------------
  merchantCount:
    type: Number
    defaultValue: 1

  warehouseCountAll:
    type: Number
    defaultValue: 1

  staffCountAll:
    type: Number
    defaultValue: 1

  customerCountAll:
    type: Number
    defaultValue: 0

  stockProductCount:
    type: Number
    defaultValue: 0

  availableProductCount:
    type: Number
    defaultValue: 0