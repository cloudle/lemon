simpleSchema.roles = new SimpleSchema
  group:
    type: String

  parent:
    type: String
    optional: true

  creator:
    type: String
    optional: true

  name:
    type: String

  description:
    type: String
    optional: true

  roles:
    type: String
    optional: true

  permissions:
    type: [String]
    optional: true

  allowDelete:
    type: Boolean
    defaultValue: true

  version: { type: simpleSchema.Version }