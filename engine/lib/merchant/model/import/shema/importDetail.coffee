simpleSchema.importDetails = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  import:
    type: String

  product:
    type: String

  branchProduct:
    type: String

  provider:
    type: String
    optional: true

  importQuality:
    type: Number

  importPrice:
    type: Number
    decimal: true

  totalPrice:
    type: Number

  salePrice:
    type: Number
    optional: true

  expire:
    type: Date
    optional: true

  productionDate:
    type: Date
    optional: true

  timeUse:
    type: Number
    optional: true

  color:
    type: String
    optional: true

  styles:
    type: String
    optional: true

  submitted:
    type: Boolean
    defaultValue: false

  unit:
    type: String
    optional: true

  unitQuality:
    type: Number
    optional: true

  unitPrice:
    type: Number
    optional: true

  conversionQuality:
    type: Number
    optional: true

  buildInProduct:
    type: String
    optional: true

  buildInProductUnit:
    type: String
    optional: true

  version: { type: simpleSchema.Version }