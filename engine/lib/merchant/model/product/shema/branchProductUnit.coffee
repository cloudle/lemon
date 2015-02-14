simpleSchema.branchProductUnits = new SimpleSchema
  price:
    type: Number
    optional: true

  importPrice:
    type: Number
    optional: true

  alertQuality:
    type: Number
    optional: true

  upperGapQuality:
    type: Number
    optional: true
#-----------------------------------------------
  parentMerchant:
    type: String

  merchant:
    type: String

  product:
    type: String

  buildInProduct:
    type: String
    optional: true

  productUnit:
    type: String

  buildInProductUnit:
    type: String
    optional: true

  creator:
    type: String
    optional: true
  version: { type: simpleSchema.Version }
#-----------------------------------------------

Schema.add "branchProductUnits", "BranchProductUnit", class BranchProductUnit
  @name: "Branch Product Unit"
  @optionByProfile: (productId, productUnitId, profile)->
    branchProductUnitOption =
      parentMerchant : profile.parentMerchant
      merchant       : profile.currentMerchant
      product        : productId
      productUnit    : productUnitId
      creator        : profile.user
    return branchProductUnitOption