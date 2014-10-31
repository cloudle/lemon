Schema.add 'imports', class Import
  @findBy: (importId, warehouseId = null, merchantId = null)->
    myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.findOne({
      _id      : importId
      merchant : merchantId ? myProfile.currentMerchant
      warehouse: warehouseId ? myProfile.currentWarehouse
    })

  @myHistory: (creatorId, warehouseId = null, merchantId = null)->
    myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.find({
      creator   : creatorId ? myProfile.user
      warehouse : warehouseId ? myProfile.currentWarehouse
      merchant  : merchantId ? myProfile.currentMerchant
    })

  @createdNewBy: (description, myProfile = null)->
    myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.insert
      merchant   : myProfile.currentMerchant
      warehouse  : myProfile.currentWarehouse
      creator    : myProfile.user
      finish     : false
      submitted  : false
      totalPrice : 0
      deposit    : 0
      debit      : 0

