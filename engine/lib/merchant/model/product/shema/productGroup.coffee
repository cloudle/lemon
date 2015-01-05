simpleSchema.productGroups = new SimpleSchema
  merchant:
    type: String

  creator:
    type: String

  name:
    type: String

  level:
    type: Number
    defaultValue: 1

  image:
    type: String
    optional: true

  childGroup:
    type: [String]
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }

