simpleSchema.branchProductSummaries = new SimpleSchema
  price:
    type: Number
    optional: true

  importPrice:
    type: Number
    optional: true

  alertQuality:
    type: Number
    defaultValue: 0

  upperGapQuality:
    type: Number
    optional: true

#-----------------------------------------------
  parentMerchant:
    type: String

  merchant:
    type: String

  warehouse:
    type: String
    optional: true

  buildInProduct:
    type: String
    optional: true

  product:
    type: String

  basicDetailModeEnabled:
    type: Boolean
    defaultValue: true

  salesQuality:
    type: Number
    defaultValue: 0

  returnQualityByCustomer:
    type: Number
    defaultValue: 0

  returnQualityByDistributor:
    type: Number
    defaultValue: 0

  totalQuality:
    type: Number
    defaultValue: 0

  availableQuality:
    type: Number
    defaultValue: 0

  inStockQuality:
    type: Number
    defaultValue: 0

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }
#-----------------------------------------------

Schema.add "branchProductSummaries", "BranchProductSummary", class BranchProductSummary
  @name: "Merchant Product Summaries"
  @optionByProfile: (productId, buildInProductId = null, profile)->
    branchProductOption =
      parentMerchant    : profile.parentMerchant
      merchant          : profile.currentMerchant
      warehouse         : profile.currentWarehouse
      product           : productId
    branchProductOption.buildInProduct = buildInProductId if buildInProductId
    return branchProductOption
