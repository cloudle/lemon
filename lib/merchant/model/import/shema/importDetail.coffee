simpleSchema.importDetails = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  import:
    type: String

  product:
    type: String

  provider:
    type: String
    optional: true

  importQuality:
    type: Number

  importPrice:
    type: Number

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


  version: { type: simpleSchema.Version }

