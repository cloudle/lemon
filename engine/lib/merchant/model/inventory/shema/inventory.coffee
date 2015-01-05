simpleSchema.inventories = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  inventoryCode:
    type: String
    optional: true

  description:
    type: String

  resolved:
    type: Boolean
    defaultValue: false

  resolveDescription:
    type: String
    optional: true

  detail:
    type: Boolean
    defaultValue: false

# xac nhan nhan vien
  submit:
    type: Boolean
    defaultValue: false

# hoan thanh xac nhan quan ly
  success:
    type: Boolean
    defaultValue: false

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

