Meteor.methods
  createNewBranch: (name, address)->
    myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if myProfile and name
      option =
        parent  : myProfile.parentMerchant
        creator : myProfile.user
        name    : name
      option.address = address if address

      merchantId = Schema.merchants.insert(option)
      Schema.warehouses.insert Warehouse.newDefault({merchantId: merchantId})
      Schema.metroSummaries.insert MetroSummary.newByMerchant(merchantId)
      MetroSummary.updateMetroSummaryBy(['branch'])


  destroyBranch: (branchId)->
    myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if myProfile and branch = Schema.merchants.findOne({_id: branchId, parent: myProfile.parentMerchant})
      if !Schema.products.findOne({merchant: branchId, totalQuality: {$gt: 0}})
        Schema.warehouses.remove({merchant: branchId})
        Schema.metroSummaries.remove({merchant: branchId})
        Schema.merchants.remove({_id: branchId})
        MetroSummary.updateMetroSummaryBy(['branch'])
        return 'Xóa thành công chi nhánh.'