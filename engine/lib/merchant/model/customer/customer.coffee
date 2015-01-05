Schema.add 'customers', "Customer", class Customer
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})
  @insideBranch: (branchId) -> @schema.find({currentMerchant: branchId})