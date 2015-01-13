simpleSchema.merchantProducts = new SimpleSchema
  parentMerchant:
    type: String

  product:
    type: String

  availableQuality:
    type: Number
    defaultValue: 0

  inStockQuality:
    type: Number
    defaultValue: 0

  totalQuality:
    type: Number
    defaultValue: 0

  salesQuality:
    type: Number
    defaultValue: 0

  returnQualityByCustomer:
    type: Number
    defaultValue: 0

  returnQualityByDistributor:
    type: Number
    defaultValue: 0

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }

Schema.add "merchantProducts", "MerchantProducts", class MerchantProducts
  @name: "Merchant Products"