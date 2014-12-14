simpleSchema.productUnits = new SimpleSchema
  product:
    type: String

  productCode:
    type: String

  unit:
    type: String
    optional: true

  conversionQuality:
    type: Number
    min: 0
    defaultValue: 1

  price:
    type: Number
    defaultValue: 0

  allowDelete:
    type: Boolean
    defaultValue: true

  version: { type: simpleSchema.Version }

Schema.add "productUnits", "ProductUnit", class ProductUnit
  @name: "Product Unit"