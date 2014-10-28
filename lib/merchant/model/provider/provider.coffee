Schema.add 'providers', class Provider
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})
  @insideBranch: (branchId) -> @schema.find({merchant: branchId})