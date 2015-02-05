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

  productUnit:
    type: String

  creator:
    type: String
    optional: true
  version: { type: simpleSchema.Version }
#-----------------------------------------------

Schema.add "branchProductUnits", "BranchProductUnit", class BranchProductUnit
  @name: "Branch Product Unit"