Schema.add 'providers', class Provider
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})