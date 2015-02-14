simpleSchema.partnerSales = new SimpleSchema
  parentMerchant:
    type: String

  merchant:
    type: String
    optional: true

  warehouse:
    type: String
    optional: true

  creator:
    type: String
    optional: true

  partner:
    type: String
    optional: true

  partnerImport:
    type: String
    optional: true

  description:
    type: String
    optional: true

  totalPrice:
    type: Number
    defaultValue: 0

  deposit:
    type: Number
    defaultValue: 0

  debit:
    type: Number
    defaultValue: 0

  status:
    type: String
    defaultValue: 'new'

  allowDelete:
    type: Boolean
    defaultValue: true

  latestDebtBalance:
    type: Number
    defaultValue: 0

  debtBalanceChange:
    type: Number
    defaultValue: 0

  beforeDebtBalance:
    type: Number
    defaultValue: 0

  styles:
    type: String
    defaultValue: Helpers.RandomColor()
  version: { type: simpleSchema.Version }

Schema.add 'partnerSales', "PartnerSale", class PartnerSale
  @findBy: (importId, warehouseId = null, merchantId = null)->

