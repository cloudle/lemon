simpleSchema.productUnits = new SimpleSchema
  buildInProduct:
    type: String
    optional: true

  productCode:
    type: String
    optional: true

  image:
    type: String
    optional: true

  unit:
    type: String
    optional: true

  conversionQuality:
    type: Number
    min: 1
    optional: true
#-----------------------------------------------
# image, price, importPrice
  hasOverride:
    type: [String]
    optional: true

  buildInProductUnit:
    type: String
    optional: true

  price:
    type: Number
    min: 0
    optional: true

  importPrice:
    type: Number
    min: 0
    optional: true
#-----------------------------------------------
  parentMerchant:
    type: String
    optional: true

  merchant:
    type: String
    optional: true

  createMerchant:
    type: String
    optional: true

  product:
    type: String

  creator:
    type: String
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }

#-----------------------------------------------
Schema.add "productUnits", "ProductUnit", class ProductUnit
  @name: "Product Unit"
  @optionByProfile: (productId, buildInProductUnit, profile)->
    productUnitOption =
      parentMerchant    : profile.parentMerchant
      createMerchant    : profile.currentMerchant
      merchant          : profile.currentMerchant
      warehouse         : profile.currentWarehouse
      creator           : profile.user
      product           : productId
      buildInProduct    : buildInProductUnit.buildInProduct
      buildInProductUnit: buildInProductUnit._id
    return productUnitOption

