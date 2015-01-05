simpleSchema.productQualities = new SimpleSchema
  product:
    type: String

  merchant:
    type: String

  totalQuality:
    type: Number
    min: 0
    defaultValue: 0

  availableQuality:
    type: Number
    min: 0
    defaultValue: 0

  inStockQuality:
    type: Number
    min: 0
    defaultValue: 0

  alertQuality:
    type: Number
    min: 0
    defaultValue: 0

  upperGapQuality:
    type: Number
    min: 0
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  version: { type: simpleSchema.Version }

Schema.add "productQualities", "ProductQuality", class ProductQuality
  @name: "Product Quality"