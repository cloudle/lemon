simpleSchema.userProfiles = new SimpleSchema
  user:
    type: String

  creator:
    type: String
    optional: true

  isRoot:
    type: Boolean

  userType:
    type: String
    optional: true

  parentMerchant:
    type: String
    optional: true

  currentMerchant:
    type: String
    optional: true

  currentWarehouse:
    type: String
    optional: true

  fullName:
    type: String
    optional: true

  dateOfBirth:
    type: Date
    optional: true

  gender:
    type: Boolean
    optional: true

  avatar:
    type: String
    defaultValue: 'images/avatars/no-avatar.jpg'

  startWorkingDate:
    type: Date
    optional: true

  roles:
    type: [String]
    optional: true

  systemVersion:
    type: String
    optional: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }

Schema.add 'userProfiles'