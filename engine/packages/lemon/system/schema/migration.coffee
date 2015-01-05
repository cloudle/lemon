simpleSchema.migrations = new SimpleSchema
  systemVersion:
    type: String

  creator:
    type: String
    optional: true

  owner:
    type: String
    optional: true

  description:
    type: String

  group:
    type: [String]

  color:
    type: String
    optional: true

  version: { type: simpleSchema.Version }

Schema.add 'migrations'