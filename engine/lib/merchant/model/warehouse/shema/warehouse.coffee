simpleSchema.warehouses = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  merchant:
    type: String


  creator:
    type: String

  name:
    type: String

  isRoot:
    type: Boolean

  checkingInventory:
    type: Boolean

  inventory:
    type: String
    optional: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  location: { type: simpleSchema.Location, optional: true }
  version: { type: simpleSchema.Version }

