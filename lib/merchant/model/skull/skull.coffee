Schema.add 'skulls', "Skull", class Skull
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})
  @insideBranch: (branchId) -> @schema.find({merchant: branchId})