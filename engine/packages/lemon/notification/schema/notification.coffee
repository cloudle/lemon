simpleSchema.notifications = new SimpleSchema
  sender:
    type: String
    optional: true

  receiver:
    type: String
    optional: true

  message:
    type: String

  product:
    type: String
    optional: true

  group:
    type: String
    optional: true

  isRequest:
    type: Boolean
    defaultValue: false

  notificationType:
    type: String

  characteristic:
    type: String
    optional: true

  seen:
    type: Boolean
    defaultValue: false

  confirmed:
    type: Boolean
    defaultValue: false

  version: { type: simpleSchema.Version }