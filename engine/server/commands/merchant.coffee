Meteor.methods
  registerMerchant: (email, password, companyName, contactPhone) ->
    userId = Accounts.createUser {email: email, password: password}
    user = Meteor.users.findOne(userId)

    if !user
      throw new Meteor.Error("loi tao tai khoan", "khong the tao tai khoan")
      return

    merchantId = Schema.merchants.insert({owner: userId, creator: userId, name: companyName})
    Schema.merchantProfiles.insert
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

    Schema.userProfiles.insert
      user              : userId
      parentMerchant    : merchantId
      currentMerchant   : merchantId
      currentWarehouse  : warehouseId
      isRoot            : true
      systemVersion     : Schema.systems.findOne().version

    Schema.metroSummaries.insert MetroSummary.newByMerchant(merchantId)
    Schema.branchProfiles.insert { merchant: merchantId }

    Schema.userSessions.insert { user: userId }

    return user

  createMerchantStaff: (email, password, profile)->
    userId = Accounts.createUser {email: email, password: password}
    user = Meteor.users.findOne(userId)

    if !user then throw new Meteor.Error("loi tao tai khoan", "khong the tao tai khoan"); return

    profile.user = userId
    Schema.userProfiles.insert profile
    MetroSummary.updateMetroSummaryByStaff(userId)
    return user

  updateEmailStaff: (email, password, profileId)->
    userId = Accounts.createUser {email: email, password: password}
    Schema.userProfiles.update profileId, $set:{user: userId}
    Schema.userSessions.insert {user: userId}
    Schema.userOptions.insert {user: userId}

  resetMerchant: ->
    profile = Schema.userProfiles.findOne({user: Meteor.userId(), isRoot: true})
    if profile
      allMerchant  = Schema.merchants.find({$or:[{_id: profile.parentMerchant }, {parent: profile.parentMerchant}]}).fetch()
      allWarehouse = Schema.warehouses.find({$or:[{merchant: profile.parentMerchant }, {parentMerchant: profile.parentMerchant}]}).fetch()
      allMerchantIds = _.pluck(allMerchant, '_id')

      Schema.providers.remove({parentMerchant: profile.parentMerchant})
      Schema.distributors.remove({parentMerchant: profile.parentMerchant})
      Schema.customers.remove({parentMerchant: profile.parentMerchant})
      Schema.customerAreas.remove({parentMerchant: profile.parentMerchant})

      Schema.deliveries.remove({merchant: {$in:allMerchantIds}})
      Schema.imports.remove({merchant: {$in:allMerchantIds}})
      Schema.importDetails.remove({merchant: {$in:allMerchantIds}})
      Schema.inventories.remove({merchant: {$in:allMerchantIds}})
      Schema.inventoryDetails.remove({merchant: {$in:allMerchantIds}})
      Schema.products.remove({merchant: {$in:allMerchantIds}})
      Schema.productDetails.remove({merchant: {$in:allMerchantIds}})
      Schema.saleExports.remove({merchant: {$in:allMerchantIds}})
      Schema.transactions.remove({merchant: {$in:allMerchantIds}})
      Schema.transactionDetails.remove({merchant: {$in:allMerchantIds}})

      for order in Schema.orders.find({merchant: {$in:allMerchantIds}}).fetch()
        Schema.orders.remove(order._id)
        Schema.orderDetails.remove({order: order._id})

      for item in Schema.returns.find({merchant: {$in:allMerchantIds}}).fetch()
        Schema.returns.remove(item._id)
        Schema.returnDetails.remove({return: item._id})

      for item in Schema.sales.find({merchant: {$in:allMerchantIds}}).fetch()
        Schema.sales.remove(item._id)
        Schema.saleDetails.remove({sale: item._id})

      for item in Schema.userProfiles.find({parentMerchant: profile.parentMerchant}).fetch()
        if item._id != profile._id
          Schema.userProfiles.remove({user: item.user})
          Schema.userSessions.remove({user: item.user})
          Schema.userOptions.remove({user: item.user})
          Meteor.users.remove(item.user)

      for warehouse in allWarehouse
        if warehouse.parentMerchant is warehouse.merchant and warehouse.isRoot is true
        else Schema.warehouses.remove(warehouse._id)

      Schema.metroSummaries.remove(parentMerchant: profile.parentMerchant)
      Schema.merchants.remove(parent: profile.parentMerchant)

      Schema.metroSummaries.insert MetroSummary.newByMerchant(profile.parentMerchant)

  checkProductExpireDate: (value)->
    Apps.Merchant.checkProductExpireDate(Schema.userProfiles.findOne({user: Meteor.userId()}), value)

  checkReceivableExpireDate: (value)->
    Apps.Merchant.checkReceivableExpireDate(Schema.userProfiles.findOne({user: Meteor.userId()}), value)

  checkPayableExpireDate: (value)->
    Apps.Merchant.checkPayableExpireDate(Schema.userProfiles.findOne({user: Meteor.userId()}), value)


  checkExpireDateTransaction: (transactionId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if parentMerchantProfile = Schema.branchProfiles.findOne({merchant: profile.parentMerchant})
        Apps.Merchant.checkExpireDateCreateTransaction(profile, transactionId, parentMerchantProfile.notifyReceivableExpireRange ? 90)


  createGeraMerchant: (merchantId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      merchantId = profile.parentMerchant if !merchantId
      findMerchant = Schema.merchants.findOne({_id: merchantId, merchantType: 'merchant', parent: {$exists: false} })
      findGeraMerchant = Schema.merchants.findOne({merchantType: 'gera'})
      Schema.merchants.update findMerchant._id, $set:{merchantType: 'gera'} if !findGeraMerchant and findMerchant

  upMerchantToAgency: (merchantId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      merchantId = profile.parentMerchant if !merchantId
      findMerchant = Schema.merchants.findOne({_id: merchantId, merchantType: 'merchant', parent: {$exists: false}})
      if findMerchant
        Schema.merchants.find({$or: [{_id: findMerchant._id}, {parent: findMerchant._id}] }).forEach(
          (branch) -> Schema.merchants.update findMerchant._id, $set:{merchantType: 'agency'}
        )

  updateParentMerchant: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      Schema.merchants.find({_id: "fd3n2DxNZKbbs5gkE"}).forEach(
        (merchant) ->
          parentMerchant = if merchant.parent then merchant.parent else merchant._id
          Schema.products.find({merchant: merchant._id}).forEach(
            (product) ->
              Schema.products.update product._id, $set:{parentMerchant: parentMerchant}
              branchProductSummaries =
                parentMerchant            : parentMerchant
                merchant                  : merchant._id
                product                   : product._id
                warehouse                 : product.warehouse
                alertQuality              : 0
                salesQuality              : 0
                returnQualityByCustomer   : 0
                returnQualityByDistributor: 0
                totalQuality              : 0
                availableQuality          : 0
                inStockQuality            : 0

              Schema.productDetails.find({product: product._id, merchant: product.merchant}).forEach(
                (productDetail)->
                  Schema.productDetails.update productDetail._id, $set:{parentMerchant: parentMerchant}
                  branchProductSummaries.availableQuality           += productDetail.inStockQuality
                  branchProductSummaries.inStockQuality             += productDetail.availableQuality
                  branchProductSummaries.totalQuality               += productDetail.importQuality
              )
              Schema.saleDetails.find({product: product._id}).forEach(
                (saleDetail)-> branchProductSummaries.salesQuality += saleDetail.quality
              )
              Schema.branchProductSummaries.insert branchProductSummaries
          )

      )


  updateMerchantDataBase: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      #thêm merchantType cho merchant
      Schema.merchants.find({merchantType: {$nin:['merchant', 'agency', 'gera']} }).forEach(
        (merchant) ->
          Schema.merchants.update merchant._id, $set:{merchantType: 'merchant'}
          Schema.userProfiles.update {currentMerchant: merchant._id}, $set:{userType: 'merchant'}

          parentMerchant = if merchant.parent then merchant.parent else merchant._id
          Schema.products.find({merchant: merchant._id}).forEach(
            (product) ->
              Schema.products.update product._id, $set:{parentMerchant: parentMerchant}
              branchProductSummaries =
                parentMerchant            : parentMerchant
                merchant                  : merchant._id
                product                   : product._id
                warehouse                 : product.warehouse
                alertQuality              : 0
                salesQuality              : 0
                returnQualityByCustomer   : 0
                returnQualityByDistributor: 0
                totalQuality              : 0
                availableQuality          : 0
                inStockQuality            : 0

              Schema.productDetails.find({product: product._id, merchant: product.merchant}).forEach(
                (productDetail)->
                  Schema.productDetails.update productDetail._id, $set:{parentMerchant: parentMerchant}
                  branchProductSummaries.availableQuality           += productDetail.inStockQuality
                  branchProductSummaries.inStockQuality             += productDetail.availableQuality
                  branchProductSummaries.totalQuality               += productDetail.importQuality
              )
              Schema.saleDetails.find({product: product._id}).forEach(
                (saleDetail)-> branchProductSummaries.salesQuality += saleDetail.quality
              )
              Schema.branchProductSummaries.insert branchProductSummaries
          )
      )

      #set merchant của vtnamphuong@gera.vn lên làm gera

      #set merchant của vtnamphuong@gera.vn lên làm agency
      merchantId_VTNamPhuong = "fd3n2DxNZKbbs5gkE"
      Schema.merchants.update merchantId_VTNamPhuong, $set:{merchantType: 'agency'}
      Schema.userProfiles.update {merchant: merchantId_VTNamPhuong}, $set:{userType: 'agency'}


      #lấy dữ liệu sản phẩm của vtnamphuong@gera.vn làm buildInProduct
#      Schema.products.find({merchant: "fd3n2DxNZKbbs5gkE", buildInProduct:{$exists: false} }).forEach(
      Schema.products.find({merchant: "fd3n2DxNZKbbs5gkE"}).forEach(
        (product) ->
          if product.name and product.productCode
            buildInProduct = {
              creator    : profile.user
              name       : product.name
              productCode: product.productCode
              status     : 'onSold'
            }
            buildInProduct.basicUnit = product.basicUnit if product.basicUnit
            buildInProduct.image = product.image if product.image
            buildInProduct.description = product.description if product.description

            if buildInProduct._id = Schema.buildInProducts.insert buildInProduct
              productSet = {buildInProduct: buildInProduct._id}
              productUnSet = {name: "", image: "", productCode: "", basicUnit: "", description: ""}
              Schema.products.update product._id, $set:productSet, $unset:productUnSet

              Schema.productUnits.find({product: product._id}).forEach(
                (productUnit)->
                  if productUnit.unit and productUnit.productCode and productUnit.conversionQuality
                    buildInProductUnit = {
                      buildInProduct   : buildInProduct._id
                      creator          : profile.user
                      productCode      : productUnit.productCode
                      unit             : productUnit.unit
                      conversionQuality: productUnit.conversionQuality
                    }
                    buildInProductUnit.image = productUnit.image if productUnit.image

                    if buildInProductUnit._id = Schema.buildInProductUnits.insert buildInProductUnit
                      productUnitSet = {buildInProductUnit: buildInProductUnit._id}
                      productUnitUnSet = {buildInProduct: "", productCode: "", image: "", unit: "", conversionQuality: ""}
                      Schema.productUnits.update productUnit._id, $set: productUnitSet, $unset: productUnitUnSet
              )
        )
