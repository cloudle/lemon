Meteor.methods
  registerMerchant: (email, password, companyName, contactPhone) ->
    userId = Accounts.createUser {email: email, password: password}
    user = Meteor.users.findOne(userId)

    if !user
      throw new Meteor.Error("loi tao tai khoan", "khong the tao tai khoan")
      return

    merchantId = Schema.merchants.insert({owner: userId, creator: userId, name: companyName})
    Schema.merchantPurchases.insert
      merchant          : merchantId
      merchantRegistered: false
      user              : userId
      companyName       : companyName
      contactPhone      : contactPhone
      merchantName      : 'Trụ Sở'
      warehouseName     : 'Kho Trụ Sở'
    warehouseId = Schema.warehouses.insert Warehouse.newDefault {
      merchantId        : merchantId
      parentMerchantId  : merchantId
      creator           : userId
      name              : 'Kho Trụ Sở'
    }
    Schema.metroSummaries.insert MetroSummary.newByMerchant(merchantId)

    Schema.userProfiles.insert
      user              : userId
      parentMerchant    : merchantId
      currentMerchant   : merchantId
      currentWarehouse  : warehouseId
      isRoot            : true
      systemVersion     : Schema.systems.findOne().version

    Schema.userSessions.insert { user: userId }


    return user