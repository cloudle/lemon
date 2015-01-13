simpleSchema.buildInProducts = new SimpleSchema
  name:
    type: String

  image:
    type: String
    optional: true

  productCode:
    type: String
    optional: true

  basicUnit:
    type: String
    optional: true

  skulls:
    type: [String]
    optional: true

  groups:
    type: [String]
    optional: true

  description:
    type: String
    optional: true

  price:
    type: Number
    defaultValue: 0

  importPrice:
    type: Number
    defaultValue: 0

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

Schema.add "buildInProducts", "BuildInProducts", class BuildInProducts
  @name: "BuildIn Products"
