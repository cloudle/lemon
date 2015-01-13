simpleSchema.productUnits = new SimpleSchema
  productCode:
    type: String
    optional: true

  unit:
    type: String
    optional: true

  conversionQuality:
    type: Number
    min: 1
    optional: true

  price:
    type: Number
    min: 0
    optional: true

  importPrice:
    type: Number
    min: 0
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  version: { type: simpleSchema.Version }
#-----------------------------------------------
  product:
    type: String

  buildInProductUnit:
    type: String
    optional: true

  expireDate:
    type: Date
    optional: true

  buildIn:
    type: Boolean
    defaultValue: true




Schema.add "productUnits", "ProductUnit", class ProductUnit
  @name: "Product Unit"