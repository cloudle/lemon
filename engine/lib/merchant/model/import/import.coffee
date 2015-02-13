Schema.add 'imports', "Import", class Import
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
      $and : [
        creator   : creatorId ? myProfile.user
        warehouse : warehouseId ? myProfile.currentWarehouse
        merchant  : merchantId ? myProfile.currentMerchant
        status    : {$nin: ['unSubmit']}
        $or : [{ finish : false }, { submitted : false}]
      ]
    })

  @createdNewBy: (description, distributor, myProfile)->
    if !myProfile then myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    importOption =
      parentMerchant: myProfile.parentMerchant
      merchant      : myProfile.currentMerchant
      warehouse     : myProfile.currentWarehouse
      creator       : myProfile.user

    if distributor
      importOption.distributor = distributor._id if distributor._id
      importOption.tabDisplay = Helpers.shortName2(distributor.name) if distributor.name
    importOption.description = description if description
    importOption._id = @schema.insert importOption

    if importOption._id then return importOption else return undefined



  @findHistory: (starDate, toDate, warehouseId) ->
    @schema.find({$and: [
      {warehouse: warehouseId, submitted: true}
      {'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}}
      {'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}}
    ]}, {sort: {'version.createdAt': -1}})
