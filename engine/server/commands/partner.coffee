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

        when 'delete'
          if partner.status isnt 'myMerchant' and partner.status isnt 'success'
            Schema.partners.remove partner._id
            Schema.partners.remove partner.partner
            Schema.merchantProfiles.update {merchant: partner.parentMerchant}, $pull: { merchantPartnerList: partner.buildIn }
            Schema.merchantProfiles.update {merchant: partner.buildIn}, $pull: { merchantPartnerList: partner.parentMerchant }

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

  submitPartnerSale: (partnerSale)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      partnerSaleFound = Schema.partnerSales.findOne({_id: partnerSale._id, status: 'unSubmit', parentMerchant: profile.parentMerchant})
      if partnerSaleFound.partnerImport
        #tính toán bên bán (bên xác nhận)
        partnerSaleDetails = Schema.partnerSaleDetails.find({partnerSales: partnerSaleFound._id}).fetch()
        for saleDetail in partnerSaleDetails
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

        partnerSaleUpdate = {merchant: profile.currentMerchant, warehouse: profile.currentWarehouse, creator: profile.user, status: 'success'}
        Schema.partnerSales.update partnerSaleFound._id, $set: partnerSaleUpdate

        #Tính toán bên nhập kho (bên nhập kho)
        for productDetail in Schema.productDetails.find({import: partnerSaleFound.partnerImport, status: 'unSubmit'}).fetch()
          quality = productDetail.importQuality
          incOption =
            $set: {allowDelete : false}
            $inc: {totalQuality: quality, availableQuality: quality, inStockQuality: quality}
          Schema.products.update productDetail.product, incOption
          Schema.branchProductSummaries.update productDetail.branchProduct, incOption
          Schema.productDetails.update productDetail._id, $set:{status: 'success'}
        Schema.imports.update partnerSaleFound.partnerImport, $set:{status: 'success'}

