simpleSchema.productGroups = new SimpleSchema
  parentMerchant:
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

  parentGroup:
    type: [String]
    optional: true

  childGroup:
    type: [String]
    optional: true

  description:
    type: String
    optional: true

  buildIn:
    type: Boolean
    defaultValue: false

  allowDelete:
    type: Boolean
    defaultValue: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()

  version: { type: simpleSchema.Version }

