Meteor.methods
  createNewBranch: (name, address)->
    myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if myProfile and name
      merchantId = Schema.merchants.insert({
        parent  : myProfile.parentMerchant
        creator : myProfile.user
        name    : name
        address : address if address
      })
      Schema.warehouses.insert Warehouse.newDefault({merchantId: merchantId})
      Schema.metroSummaries.insert MetroSummary.newByMerchant(merchantId)


  destroyBranch: (branchId)->
    myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    if myProfile and branch = Schema.merchants.findOne({_id: branchId, parent: myProfile.parentMerchant})
      if !Schema.products.findOne({merchant: branchId, totalQuality: {$gt: 0}})
        Schema.warehouses.remove({merchant: branchId})
        Schema.metroSummaries.remove({merchant: branchId})
        Schema.merchants.remove({_id: branchId})
        MetroSummary.updateMetroSummaryBy(['branch'])
        return 'Xóa thành công chi nhánh.'