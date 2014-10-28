simpleSchema.providers = new SimpleSchema
  parentMerchant:
    type: String

  merchant:
    type: String

  creator:
    type: String

  name:
    type: String

  representative:
    type: String
    optional: true

  phone:
    type: String
    optional: true

  manufacturer:
    type: String
    optional: true

  status:
    type: Boolean
    optional: true


  location: { type: Schema.Location, optional: true }
  version: { type: simpleSchema.Version }
