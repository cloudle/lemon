Meteor.methods
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

  registerMerchant: (email, password, companyName, contactPhone) ->
    userId = Accounts.createUser {email: email, password: password}
    user = Meteor.users.findOne(userId)

    if !user
      throw new Meteor.Error("loi tao tai khoan", "khong the tao tai khoan")
      return

    merchantId = Schema.merchants.insert({owner: userId, creator: userId, name: companyName})
    merchantProfileId = Schema.merchantProfiles.insert
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

    Schema.metroSummaries.insert
      parentMerchant: merchantId
      merchant      : merchantId
      warehouseList : [warehouseId]
      staffList     : [userId]

    Schema.merchantProfiles.update merchantProfileId, $addToSet: {
      merchantList : merchantId
      warehouseList: warehouseId
      staffList    : userId
    }

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
      Schema.productUnits.find().forEach(
        (productUnit)->
          Schema.branchProductSummaries.find({product: productUnit.product}).forEach(
            (branchProduct)->
              productUnitUpdate =
                parentMerchant: branchProduct.parentMerchant
                merchant      : branchProduct.merchant
                createMerchant: branchProduct.parentMerchant

              if branchProduct.parentMerchant is branchProduct.merchant
                Schema.productUnits.update productUnit._id, $set: productUnitUpdate
              else
                productUnitUpdate.merchant = branchProduct.merchant
                productUnitUpdate.product = branchProduct.product
                Schema.productUnits.insert productUnitUpdate
          )
      )

  updateBranchProduct: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
#      Schema.productDetails.find({branchProduct: {$exists: false}, merchant: profile.currentMerchant}).forEach(
#        (productDetail)->
#          if branchProduct = Schema.branchProductSummaries.findOne({product: productDetail.product, merchant: profile.currentMerchant})
#            Schema.productDetails.update productDetail._id, $set:{parentMerchant: profile.parentMerchant, branchProduct: branchProduct._id}
#
#      )
#
#      Schema.orders.find({merchant: profile.currentMerchant}).forEach(
#        (order) ->
#          Schema.orderDetails.find({order: order._id}).forEach(
#            (orderDetail) ->
#              if branchProduct = Schema.branchProductSummaries.findOne({product: orderDetail.product, merchant: profile.currentMerchant})
#                Schema.orderDetails.update orderDetail._id, $set:{branchProduct: branchProduct._id}
#          )
#      )

      Schema.sales.find({merchant: profile.currentMerchant}).forEach(
        (sale) ->
          Schema.saleDetails.find({sale: sale._id}).forEach(
            (saleDetail) ->
              if branchProduct = Schema.branchProductSummaries.findOne({product: saleDetail.product, merchant: profile.currentMerchant})
                Schema.saleDetails.update saleDetail._id, $set:{branchProduct: branchProduct._id}
          )
      )

#      Schema.returns.find({merchant: profile.currentMerchant}).forEach(
#        (currentReturn) ->
#          Schema.returnDetails.find({return: currentReturn._id}).forEach(
#            (returnDetail) ->
#              if branchProduct = Schema.branchProductSummaries.findOne({product: returnDetail.product, merchant: profile.currentMerchant})
#                Schema.returnDetails.update returnDetail._id, $set:{branchProduct: branchProduct._id}
#          )
#      )

  merchantActive: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      Schema.merchantProfiles.update {merchant:profile.parentMerchant}, $set: {packageClassActive: true}

  updateMerchant: ->
      Schema.products.find().forEach(
        (product) ->
          Schema.products.update product._id, $set:{branchList: [product.merchant]}
      )

  updateMerchantDataBase: ->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      countMerchant = 0
      #thêm merchantType cho merchant
#      Schema.merchants.find({merchantType: {$nin:['merchant', 'agency', 'gera']} }).forEach(
#      Schema.merchants.find({_id: "fd3n2DxNZKbbs5gkE"}).forEach(
#        (merchant) ->
#          merchantProfileUpdate =
#            merchantList        : []
#            warehouseList       : []
#            staffList           : []
#            customerList        : []
#            distributorList     : []
#            partnerList         : []
#            merchantPartnerList : []
#            productList         : []
#            geraProductList     : []
#          metroSummaryUpdate =
#            warehouseList   : []
#            staffList       : []
#            customerList    : []
#            distributorList : []
#            partnerList     : []
#            productList     : []
#            geraProductList : []
#          merchantProfileUpdate.merchantList.push merchant._id
#
#          parentMerchant = if merchant.parent then merchant.parent else merchant._id
#          Schema.merchants.update merchant._id, $set:{merchantType: 'merchant'}
#
#          Schema.products.find({merchant: merchant._id}).forEach(
#            (product) ->
#              metroSummaryUpdate.productList.push product._id
#              merchantProfileUpdate.productList.push product._id
#
#              Schema.products.update product._id, $set:
#                parentMerchant: parentMerchant
#                createMerchant: parentMerchant
#                branchList    : [product.merchant]
#                availableQuality          : 0
#                inStockQuality            : 0
#                totalQuality              : 0
#                salesQuality              : 0
#                returnQualityByDistributor: 0
#                returnQualityByCustomer   : 0
#
#              branchProductSummaries =
#                parentMerchant        : parentMerchant
#                merchant              : merchant._id
#                product               : product._id
#                warehouse             : product.warehouse
#                basicDetailModeEnabled: product.basicDetailModeEnabled
#              if !branchProduct = Schema.branchProductSummaries.findOne(branchProductSummaries)
#                branchProductId = Schema.branchProductSummaries.insert branchProductSummaries
#                branchProduct = Schema.branchProductSummaries.findOne(branchProductId) if branchProductId
#
#              if branchProduct
#                branchProductOption = {availableQuality: 0, inStockQuality: 0, totalQuality: 0, salesQuality: 0, returnQualityByDistributor: 0, returnQualityByCustomer: 0}
#                Schema.productDetails.find({product: product._id, merchant: product.merchant}).forEach(
#                  (productDetail)->
#                    Schema.productDetails.update productDetail._id, $set:{parentMerchant: parentMerchant, branchProduct: branchProduct._id}
##                    branchProductOption.availableQuality += productDetail.availableQuality if productDetail.availableQuality
##                    branchProductOption.inStockQuality   += productDetail.inStockQuality if productDetail.inStockQuality
#                    branchProductOption.totalQuality     += productDetail.importQuality if productDetail.importQuality
#                )
#                Schema.saleDetails.find({product: product._id}).forEach(
#                  (saleDetail)->
#                    Schema.saleDetails.update saleDetail._id, $set:{branchProduct: branchProduct._id}
#                    branchProductOption.salesQuality += saleDetail.quality
#                )
#                Schema.orderDetails.find({product: product._id}).forEach(
#                  (orderDetail) -> Schema.orderDetails.update orderDetail._id, $set:{branchProduct: branchProduct._id}
#                )
#                Schema.returnDetails.find({product: product._id}).forEach(
#                  (returnDetail) ->
#                    currentReturn = Schema.returns.findOne(returnDetail.return)
#                    if currentReturn?.status is 2
#                      branchProductOption.returnQualityByCustomer += returnDetail.returnQuality if currentReturn.customer
#                      branchProductOption.returnQualityByDistributor += returnDetail.returnQuality if currentReturn.distributor
#                    Schema.returnDetails.update returnDetail._id, $set:{branchProduct: branchProduct._id}
#                )
#                Schema.productUnits.find({product: product._id}).forEach(
#                  (productUnit)->
#                    productUnitUpdate =
#                      parentMerchant: parentMerchant
#                      merchant      : merchant._id
#                      createMerchant: parentMerchant
#                    Schema.productUnits.update productUnit._id, $set: productUnitUpdate
#
#                    branchProductUnit =
#                      parentMerchant: parentMerchant
#                      merchant      : merchant._id
#                      product       : productUnit.product
#                      productUnit   : productUnit._id
#                    Schema.branchProductUnits.insert branchProductUnit if !Schema.branchProductUnits.findOne(branchProductUnit)
#                )
#
#                branchProductOption.totalQuality = branchProductOption.totalQuality - branchProductOption.returnQualityByDistributor
#                if branchProduct.basicDetailModeEnabled
#                  branchProductOption.availableQuality = branchProductOption.totalQuality
#                  branchProductOption.inStockQuality   = branchProductOption.totalQuality
#                else
#                  branchProductOption.availableQuality = branchProductOption.totalQuality - branchProductOption.salesQuality + branchProductOption.returnQualityByCustomer
#                  branchProductOption.inStockQuality   = branchProductOption.totalQuality - branchProductOption.salesQuality + branchProductOption.returnQualityByCustomer
#
#                Schema.branchProductSummaries.update branchProduct._id, $set:branchProductOption
#                Schema.products.update product._id, $inc:
#                  availableQuality          : branchProductOption.availableQuality
#                  inStockQuality            : branchProductOption.inStockQuality
#                  totalQuality              : branchProductOption.totalQuality
#                  salesQuality              : branchProductOption.salesQuality
#                  returnQualityByDistributor: branchProductOption.returnQualityByDistributor
#                  returnQualityByCustomer   : branchProductOption.returnQualityByCustomer
#
#          )
#
#          Schema.warehouses.find({merchant: merchant._id}).forEach(
#            (warehouse)->
#              metroSummaryUpdate.warehouseList.push warehouse._id
#              merchantProfileUpdate.warehouseList.push warehouse._id
#          )
#          Schema.userProfiles.find({currentMerchant: merchant._id}).forEach(
#            (userProfile)->
#              metroSummaryUpdate.staffList.push userProfile._id
#              merchantProfileUpdate.staffList.push userProfile._id
#              Schema.userProfiles.update userProfile._id, $set:{userType: 'merchant'}
#          )
#          Schema.customers.find({currentMerchant: merchant._id}).forEach(
#            (customer)->
#              metroSummaryUpdate.customerList.push customer._id
#              merchantProfileUpdate.customerList.push customer._id
#          )
#          Schema.distributors.find({merchant: merchant._id}).forEach(
#            (distributor)->
#              metroSummaryUpdate.distributorList.push distributor._id
#              merchantProfileUpdate.distributorList.push distributor._id
#          )
#          Schema.metroSummaries.update {merchant: merchant._id}, $set: metroSummaryUpdate
#          Schema.merchantProfiles.update {merchant: parentMerchant}, $set: merchantProfileUpdate
#
#          countMerchant = countMerchant + 1
#          console.log countMerchant
#      )


#      #set merchant của vtnamphuong@gera.vn lên làm agency
#      merchantId_VTNamPhuong = "fd3n2DxNZKbbs5gkE"
#      Schema.merchants.update merchantId_VTNamPhuong, $set:{merchantType: 'agency'}
#      Schema.userProfiles.update {merchant: merchantId_VTNamPhuong}, $set:{userType: 'agency'}


#      lấy dữ liệu sản phẩm của vtnamphuong@gera.vn làm buildInProduct
      geraProductList = []
      Schema.products.find({merchant: "fd3n2DxNZKbbs5gkE", buildInProduct:{$exists: false} }).forEach(
#      Schema.products.find({merchant: "fd3n2DxNZKbbs5gkE"}).forEach(
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
              geraProductList.push buildInProduct._id
      )
      Schema.metroSummaries.update {merchant: "fd3n2DxNZKbbs5gkE"}, $set: {geraProductList: geraProductList}
      Schema.merchantProfiles.update {merchant: "fd3n2DxNZKbbs5gkE"}, $set: {geraProductList: geraProductList}

      Meteor.call('reUpdateOrderCode')

  checkProduct: ->
    merchantList = []
    Schema.products.find({merchant: "fd3n2DxNZKbbs5gkE"}).forEach(
#    Schema.products.find().forEach(
      (product)->
        Schema.branchProductSummaries.find({product: product._id}).forEach(
          (branchProduct)->
            if product.totalQuality isnt branchProduct.totalQuality or product.availableQuality isnt branchProduct.availableQuality
              merchantList.push branchProduct._id
        )
    )
    console.log _.union(merchantList)
    console.log 'checkProduct Ok!'
