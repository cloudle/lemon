simpleSchema.merchants = new SimpleSchema
  parent:
    type: String
    optional: true

  creator:
    type: String
    optional: true

  owner:
    type: String
    optional: true

  name:
    type: String
    optional: true #optional tren danh nghia, se phai dien vao trong buoc dang ky!

  address:
    type: String
    optional: true

  location:
    type: [String]
    optional: true

  area:
    type: [String]
    optional: true

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
    optional: true

  version: { type: simpleSchema.Version }