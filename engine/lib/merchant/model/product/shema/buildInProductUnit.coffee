simpleSchema.buildInProductUnits = new SimpleSchema
  creator:
    type: String

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

  status:
    type: String
    defaultValue: 'New'

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }

Schema.add "buildInProductUnits", "BuildInProductUnits", class BuildInProductUnits
  @name: "BuildIn Product Unit"