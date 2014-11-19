Schema.add 'distributors', "Distributor", class Distributor
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})