subtractQualityOnSales = (stockingItems, sellingItem) ->
  transactionQuality = 0
  for productDetail in stockingItems
    requiredQuality = sellingItem.quality - transactionQuality
    if productDetail.availableQuality > requiredQuality then  takenQuality = requiredQuality
    else takenQuality = productDetail.availableQuality

    Schema.partnerSaleDetails.update sellingItem._id, $push: {productDetail: {productDetail: productDetail._id, saleQuality: takenQuality}}
    Schema.productDetails.update productDetail._id, $inc:{availableQuality: -takenQuality, inStockQuality:-takenQuality }
    Schema.products.update productDetail.product  , $inc:{availableQuality: -takenQuality, inStockQuality:-takenQuality }
    Schema.branchProductSummaries.update productDetail.branchProduct, $inc:{availableQuality: -takenQuality, inStockQuality:-takenQuality }

    transactionQuality += takenQuality
    if transactionQuality == sellingItem.quality then break
  return transactionQuality == sellingItem.quality



Meteor.methods
  partnerToImport : (partner, profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      if partner.parentMerchant != profile.parentMerchant
        partner = Schema.partners.findOne({_id: partner._id ,parentMerchant: profile.parentMerchant})

      if partner
        importFound = Schema.imports.findOne({
          merchant: profile.currentMerchant
          creator : userId
          partner : partner._id
          finish: false
        }, {sort: {'version.createdAt': -1}})
        if !importFound then importFound = Import.createdNewBy(null, null, partner, profile)
        Schema.userSessions.update {user: userId}, {$set:{'currentImport': importFound._id}}

      else throw 'Không tìm thấy đối tác'

    catch error
      throw new Meteor.Error('partnerToImport', error)

  addMerchantPartner: (partnerMerchantProfileId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      myMerchantProfile      = Schema.merchantProfiles.findOne({merchant: profile.parentMerchant})
      partnerMerchantProfile = Schema.merchantProfiles.findOne(partnerMerchantProfileId)
      if myMerchantProfile and partnerMerchantProfile
        submitPartner =
          parentMerchant: profile.parentMerchant
          creator       : profile.user
          buildIn       : partnerMerchantProfile.merchant
          name          : partnerMerchantProfile.companyName
          phone         : partnerMerchantProfile.contactPhone
          address       : partnerMerchantProfile.contactAddress
          status        : 'submit'
        if submitPartnerId = Schema.partners.insert submitPartner
          unSubmitPartner =
            parentMerchant: partnerMerchantProfile.merchant
            creator       : profile.user
            buildIn       : myMerchantProfile.merchant
            name          : myMerchantProfile.companyName
            phone         : myMerchantProfile.contactPhone
            address       : myMerchantProfile.contactAddress
            partner       : submitPartnerId
            status        : 'unSubmit'
          if unSubmitPartnerId = Schema.partners.insert unSubmitPartner
            Schema.partners.update submitPartnerId, $set:{partner: unSubmitPartnerId}

            Schema.merchantProfiles.update myMerchantProfile._id, $addToSet: { merchantPartnerList: partnerMerchantProfile.merchant }
            Schema.merchantProfiles.update partnerMerchantProfile._id, $addToSet: { merchantPartnerList: profile.parentMerchant }

  updateMerchantPartner: (partnerId, status = 'submit')->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      partner = Schema.partners.findOne({_id: partnerId, parentMerchant: profile.parentMerchant})
      switch status
        when 'submit'
          if partner.status is 'unSubmit'
            Schema.partners.update partner._id, $set:{status: 'success', creator: profile.user}
            Schema.partners.update partner.partner, $set:{status: 'success'}
            Schema.merchantProfiles.update {merchant: partner.parentMerchant}, $addToSet: {partnerList: partner._id}
            Schema.merchantProfiles.update {merchant: partner.buildIn}, $addToSet: {partnerList: partner.partner}

        when 'unSubmit'
          if partner.status isnt 'success'
            Schema.partners.remove partner._id
            Schema.partners.remove partner.partner
            Schema.merchantProfiles.update {merchant: partner.parentMerchant}, $pull: { merchantPartnerList: partner.buildIn }
            Schema.merchantProfiles.update {merchant: partner.buildIn}, $pull: { merchantPartnerList: partner.parentMerchant }

        when 'delete'
          if partner.status is 'myMerchant' or partner.status is 'success' or partner.status is 'unDelete'
            partnerImportHistory = Schema.imports.findOne({partner: partner._id, submitted: true})
            partnerImportHistory = Schema.imports.findOne({partner: partner.partner, submitted: true}) if partner.partner and !partnerImportHistory

            if partnerImportHistory
              Schema.partners.update partner._id, $set:{allowDelete: false}
              Schema.partners.update partner.partner, $set:{allowDelete: false}
            else
              if partner.status is 'myMerchant' or partner.status is 'unDelete'
                Schema.partners.remove partner._id
                if partner.partner
                  Schema.partners.remove partner.partner
                  Schema.merchantProfiles.update {merchant: partner.parentMerchant}, $pull: {partnerList: partner._id, merchantPartnerList: partner.buildIn }
                  Schema.merchantProfiles.update {merchant: partner.buildIn}, $pull: {partnerList: partner.partner, merchantPartnerList: partner.parentMerchant }
                else
                  Schema.merchantProfiles.update {merchant: partner.parentMerchant}, $pull: {partnerList: partner._id}
              else
                Schema.partners.update partner._id, $set:{status: 'delete'}
                Schema.partners.update partner.partner, $set:{status: 'unDelete'}

        when 'unDelete'
          if partner.status isnt 'success'
            Schema.partners.update partner._id, $set:{status: 'success'}
            Schema.partners.update partner.partner, $set:{status: 'success'}

  partnerDeleteHistory: (history)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if history.partnerImport
        if partnerSale = Schema.partnerSales.findOne({_id: history._id, status: 'unSubmit'})
            partnerSaleId = partnerSale._id; importId = partnerSale.partnerImport
      if history.partnerSale
        if partnerImport = Schema.imports.findOne({_id: history._id, status: 'unSubmit', merchant: profile.currentMerchant})
          partnerSaleId = partnerImport.partnerSale; importId = partnerImport._id

      if partnerSaleId and importId
        Schema.partnerSales.remove partnerSaleId
        Schema.partnerSaleDetails.remove {partnerSales: partnerSaleId}
        Schema.imports.remove importId
        Schema.importDetails.remove {import: importId}
        Schema.productDetails.remove {import: importId}

  submitPartnerSale: (partnerSaleId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      partnerSale = Schema.partnerSales.findOne({_id: partnerSaleId, status: 'unSubmit', parentMerchant: profile.parentMerchant})
      if partnerSale.partnerImport
        #tính toán bên bán (bên xác nhận)
        if myPartner = Schema.partners.findOne(partnerSale.partner)
          for saleDetail in Schema.partnerSaleDetails.find({partnerSales: partnerSale._id}).fetch()
            saleDetailOptionUpdate = {status: 'success'}
            if product = Schema.products.findOne({buildInProduct: saleDetail.buildInProduct, parentMerchant: profile.parentMerchant})
  #            if branchProduct = Schema.branchProductSummaries.findOne({buildInProduct: saleDetail.buildInProduct, merchant: profile.currentMerchant})
              if branchProduct = Schema.branchProductSummaries.findOne({product: product._id, merchant: profile.currentMerchant})
                if branchProduct.basicDetailModeEnabled is true
                  throw new Meteor.Error('partnerSubmitSale', 'Sản phẩm chưa kết sổ'); return
                if branchProduct.availableQuality < saleDetail.quality
                  throw new Meteor.Error('partnerSubmitSale', 'Số lượng sản phẩm không đủ'); return
              else
                throw new Meteor.Error('partnerSubmitSale', 'Không tìm thấy sản phẩm'); return

            saleDetailOptionUpdate.branchProduct = branchProduct._id
            saleDetailOptionUpdate.product = branchProduct.product
            if saleDetail.buildInProductUnit
              if productUnit = Schema.productUnits.findOne({buildInProductUnit: saleDetail.buildInProductUnit, merchant: profile.currentMerchant})
                saleDetailOptionUpdate.unit = productUnit._id

            importBasic = Schema.productDetails.find(
              {import: {$exists: false}, product: branchProduct.product, availableQuality: {$gt: 0}, status: {$nin: ['unSubmit']}}, {sort: {'version.createdAt': 1}}
            ).fetch()
            importProductDetails = Schema.productDetails.find(
              {import: { $exists: true}, product: branchProduct.product, availableQuality: {$gt: 0}, status: {$nin: ['unSubmit']}}, {sort: {'version.createdAt': 1}}
            ).fetch()

            combinedProductDetails = importBasic.concat(importProductDetails)
            subtractQualityOnSales(combinedProductDetails, saleDetail)
            Schema.partnerSaleDetails.update saleDetail._id, $set: saleDetailOptionUpdate

          partnerSaleUpdate =
            merchant  : profile.currentMerchant
            warehouse : profile.currentWarehouse
            creator   : profile.user
            status    : 'success'
            beforeDebtBalance: myPartner.saleCash + myPartner.paidCash - myPartner.importCash - myPartner.receiveCash
            latestDebtBalance: myPartner.saleCash + myPartner.paidCash - myPartner.importCash - myPartner.receiveCash + partnerSale.totalPrice
          Schema.partnerSales.update partnerSale._id, $set: partnerSaleUpdate
          Schema.partners.update myPartner._id, $inc:{saleCash: partnerSale.totalPrice}

        #Tính toán bên nhập kho (bên nhập kho)
        if partnerImport = Schema.imports.findOne(partnerSale.partnerImport)
          ownerPartner = Schema.partners.findOne(myPartner.partner)
          for productDetail in Schema.productDetails.find({import: partnerSale.partnerImport, status: 'unSubmit'}).fetch()
            quality = productDetail.importQuality
            incOption =
              $set: {allowDelete : false}
              $inc: {totalQuality: quality, availableQuality: quality, inStockQuality: quality}
            Schema.products.update productDetail.product, incOption
            Schema.branchProductSummaries.update productDetail.branchProduct, incOption
            Schema.productDetails.update productDetail._id, $set:{status: 'success'}

          partnerImportUpdate =
            status    : 'success'
            beforeDebtBalance: ownerPartner.saleCash + ownerPartner.paidCash - ownerPartner.importCash - ownerPartner.receiveCash
            latestDebtBalance: ownerPartner.saleCash + ownerPartner.paidCash - ownerPartner.importCash - ownerPartner.receiveCash - partnerImport.totalPrice
          Schema.imports.update partnerImport._id, $set: partnerImportUpdate
          Schema.partners.update ownerPartner._id, $inc:{importCash: partnerImport.totalPrice}

  deletePartnerTransaction: (partnerTransactionId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      option =
        _id   : partnerTransactionId
        group : 'partner'
        status: $in:['unSubmit', 'submit']
        parentMerchant: profile.parentMerchant

      if transaction = Schema.transactions.findOne(option)
        Schema.transactions.remove transaction._id
        Schema.transactions.remove transaction.parentTransaction

  submitPartnerTransaction: (partnerTransactionId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      option =
        _id   : partnerTransactionId
        group : 'partner'
        status: 'unSubmit'
        parentMerchant: profile.parentMerchant
      myTransaction = Schema.transactions.findOne(option)
      myPartner = Schema.partners.findOne({_id: myTransaction.owner, parentMerchant: profile.parentMerchant}) if myTransaction
      if myPartner.buildIn and myTransaction.parentTransaction
        ownerTransaction = Schema.transactions.findOne(myTransaction.parentTransaction)
        ownerPartner = Schema.partners.findOne(myPartner.partner)

      if ownerTransaction and ownerPartner and myTransaction.debtBalanceChange is ownerTransaction.debtBalanceChange
        beforeDebtMy = myPartner.saleCash + myPartner.paidCash - myPartner.importCash - myPartner.receiveCash
        beforeDebtOwner = ownerPartner.saleCash + ownerPartner.paidCash - ownerPartner.importCash - ownerPartner.receiveCash

        if myTransaction.receivable
          myPartnerOptionUpdate    = $inc: {receiveCash:myTransaction.debtBalanceChange}
          ownerPartnerOptionUpdate = $inc: {paidCash:myTransaction.debtBalanceChange}
          myTransactionUpdate    = $set: {status: 'success', beforeDebtBalance: beforeDebtMy, latestDebtBalance: beforeDebtMy - myTransaction.debtBalanceChange}
          ownerTransactionUpdate = $set: {status: 'success', beforeDebtBalance: beforeDebtOwner, latestDebtBalance: beforeDebtOwner + myTransaction.debtBalanceChange}
        else
          myPartnerOptionUpdate    = $inc: {paidCash: myTransaction.debtBalanceChange}
          ownerPartnerOptionUpdate = $inc: {receiveCash: myTransaction.debtBalanceChange}
          myTransactionUpdate    = $set: {status: 'success', beforeDebtBalance: beforeDebtMy, latestDebtBalance: beforeDebtMy + myTransaction.debtBalanceChange}
          ownerTransactionUpdate = $set: {status: 'success', beforeDebtBalance: beforeDebtOwner, latestDebtBalance: beforeDebtOwner - myTransaction.debtBalanceChange}

        Schema.partners.update myPartner._id, myPartnerOptionUpdate
        Schema.partners.update ownerPartner._id, ownerPartnerOptionUpdate
        Schema.transactions.update myTransaction._id, myTransactionUpdate
        Schema.transactions.update ownerTransaction._id, ownerTransactionUpdate


