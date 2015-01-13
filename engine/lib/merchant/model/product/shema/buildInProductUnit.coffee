simpleSchema.buildInProductUnits = new SimpleSchema
  buildInProduct:
    type: String

  productCode:
    type: String

  unit:
    type: String
    optional: true

  conversionQuality:
    type: Number
    min: 1
    defaultValue: 1

  price:
    type: Number
    defaultValue: 0

  importPrice:
    type: Number
    defaultValue: 0

  version: { type: simpleSchema.Version }

Schema.add "buildInProductUnits", "BuildInProductUnits", class BuildInProductUnits
  @name: "BuildIn Product Unit"