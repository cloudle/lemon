simpleSchema.messages = new SimpleSchema
  sender:
    type: String

  receiver:
    type: String

  message:
    type: String

  reads:
    type: [String]
    optional: true

  version: { type: simpleSchema.Version }
