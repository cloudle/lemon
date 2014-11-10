simpleSchema.inventoryDetails = new SimpleSchema
  merchant:
    type: String

  warehouse:
    type: String

  creator:
    type: String

  inventory:
    type: String

  product:
    type: String

  productDetail:
    type: String

#so luong trong kho
  lockOriginalQuality:
    type: Number
    defaultValue: 0

#so luong trong kho
  originalQuality:
    type: Number
    defaultValue: 0

#so luong kiem tra
  realQuality:
    type: Number
    defaultValue: 0

#so luong ban khi kiem kho
  saleQuality:
    type: Number
    defaultValue: 0

#so luong mat tiem lai dc
  lostQuality:
    type: Number
    defaultValue: 0

  resolved:
    type: Boolean
    defaultValue: false

  lock:
    type: Boolean
    defaultValue: false

  lockDate:
    type: Date
    optional: true

  submit:
    type: Boolean
    defaultValue: false

  submitDate:
    type: Date
    optional: true

  success:
    type: Boolean
    defaultValue: false

  successDate:
    type: Date
    optional: true

  status:
    type: Boolean
    defaultValue: false

  version: { type: simpleSchema.Version }

