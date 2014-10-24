simpleSchema.customers = new SimpleSchema
  parentMerchant:
    type: String
    optional: true

  currentMerchant:
    type: String

  creator:
    type: String

  areaMerchant:
    type: String
    optional: true

  name:
    type: String

  companyName:
    type: String
    optional: true

  phone:
    type: String

  address:
    type: String
    optional: true

  email:
    type: String
    optional: true

  dateOfBirth:
    type: Date
    optional: true

  gender:
    type: Boolean
    optional: true

  version: { type: Schema.Version }


