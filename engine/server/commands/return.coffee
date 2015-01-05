Meteor.methods
  submitDistributorReturn: (currentDistributorReturn)->
    try
      returnDetails = Schema.returnDetails.find({return: currentDistributorReturn._id}).fetch()
      (if detail.returnQuality is 0 then throw 'So luong lon hon 0.') for detail in returnDetails

      totalReturnQuality = 0
      totalReturnPrice = 0
      for item in returnDetails
        totalReturnQuality += item.returnQuality
        totalReturnPrice += item.finalPrice

      returnDetailGroups = _.chain(returnDetails)
      .groupBy("product")
      .map (group, key) ->
        return {
        product: key
        quality: _.reduce(group, ((res, current) -> res + current.returnQuality), 0)
        }
      .value()

      for returnDetail in returnDetailGroups
        quality = 0
        Schema.productDetails.find({
          distributor: currentDistributorReturn.distributor
          product: returnDetail.product
          availableQuality: {$gt:0}
        }).forEach((productDetail)-> quality += productDetail.availableQuality)
        if quality < returnDetail.quality then throw 'So luong khong du.'

      for product in returnDetailGroups
        for returnDetail in _.where(returnDetails, {product: product.product})
          if returnDetail.unit
            productDetailLikeUnit = Schema.productDetails.find({
              distributor: currentDistributorReturn.distributor
              product: returnDetail.product
              unit: returnDetail.unit
              availableQuality: {$gt:0}
            }).fetch()
            productDetailUnLikeUnit = Schema.productDetails.find({
              distributor: currentDistributorReturn.distributor
              product: returnDetail.product
              unit: { $ne: returnDetail.unit }
              availableQuality: {$gt:0}
            }).fetch()
          else
            productDetailLikeUnit = Schema.productDetails.find({
              distributor: currentDistributorReturn.distributor
              product: returnDetail.product
              unit: { $exists: false }
              availableQuality: {$gt:0}
            }).fetch()
            productDetailUnLikeUnit = Schema.productDetails.find({
              distributor: currentDistributorReturn.distributor
              product: returnDetail.product
              unit: { $exists: true }
              availableQuality: {$gt:0}
            }).fetch()

          transactionQuality = 0
          for productDetail in productDetailLikeUnit.concat(productDetailUnLikeUnit)
            requiredQuality = returnDetail.returnQuality - transactionQuality
            if productDetail.availableQuality > requiredQuality then takenQuality = requiredQuality
            else takenQuality = productDetail.availableQuality

            Schema.productDetails.update productDetail._id, $inc:{
              availableQuality: -takenQuality
              inStockQuality: -takenQuality
              returnQualityByDistributor: takenQuality
            }
            Schema.products.update productDetail.product  , $inc:{
              availableQuality: -takenQuality
              inStockQuality: -takenQuality
              totalQuality: -takenQuality
              returnQualityByDistributor: takenQuality
            }

            transactionQuality += takenQuality
            Schema.returnDetails.update returnDetail._id, $push: {productDetail: {productDetail: productDetail._id, returnQuality: takenQuality}}
            if transactionQuality == returnDetail.returnQuality then break

        distributor = Schema.distributors.findOne(currentDistributorReturn.distributor)
        Schema.distributors.update distributor._id, $inc:{importTotalCash: -totalReturnPrice, importDebt: -totalReturnPrice}

        timeLineImport = Schema.imports.findOne({distributor: currentDistributorReturn.distributor, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
        Schema.returns.update currentDistributorReturn._id, $set: {
          timeLineImport: timeLineImport._id
          status: 2
          'version.createdAt': new Date()
          allowDelete: false
          beforeDebtBalance: distributor.importDebt
          debtBalanceChange: totalReturnPrice
          latestDebtBalance: distributor.importDebt - totalReturnPrice
        }
        console.log '3'
        MetroSummary.updateMyMetroSummaryBy('createReturn', currentDistributorReturn._id)
        console.log '4'
        Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
        console.log '5'

        if distributor = Schema.distributors.findOne(currentDistributorReturn.distributor)
          console.log '6'
          Meteor.call 'distributorToReturns', distributor, Session.get('myProfile')
          console.log '7'
        console.log '8'
    catch error
      throw new Meteor.Error('submitDistributorReturn', error)