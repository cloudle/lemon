Meteor.methods
  submitDistributorReturn: (currentDistributorReturn)->
    try
      throw 'currentDistributorReturn sai' if !currentDistributorReturn
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

            productOption =
              availableQuality: -takenQuality
              inStockQuality  : -takenQuality
              returnQualityByDistributor: takenQuality
            Schema.productDetails.update productDetail._id, $inc: productOption

            productOption.totalQuality = -takenQuality
            Schema.products.update productDetail.product, $inc: productOption
            Schema.branchProductSummaries.update productDetail.branchProduct, $inc: productOption

            transactionQuality += takenQuality
            Schema.returnDetails.update returnDetail._id, $addToSet: {productDetail: {productDetail: productDetail._id, returnQuality: takenQuality}}
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

        Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
        MetroSummary.updateMyMetroSummaryBy(['createReturn'], currentDistributorReturn._id)
        Meteor.call 'updateMetroSummaryBy', 'createReturnDistributor', currentDistributorReturn._id, currentDistributorReturn.merchant

        if distributor = Schema.distributors.findOne(currentDistributorReturn.distributor)
          Meteor.call 'distributorToReturns', distributor

    catch error
      throw new Meteor.Error('submitDistributorReturn', error)

  submitCustomerReturn: (currentCustomerReturn)->
    try
      throw 'currentCustomerReturn sai' if !currentCustomerReturn
      returnDetails = Schema.returnDetails.find({return: currentCustomerReturn._id}).fetch()
      (if detail.returnQuality is 0 then throw 'So luong lon hon 0.') for detail in returnDetails

      totalReturnQuality = 0
      totalReturnPrice = 0
      for item in returnDetails
        totalReturnQuality += item.returnQuality
        totalReturnPrice += item.finalPrice

      returnDetails = _.chain(returnDetails)
      .groupBy("product")
      .map (group, key) ->
        return {
        product: key
        quality: _.reduce(group, ((res, current) -> res + current.returnQuality), 0)
        }
      .value()

      for returnDetail in returnDetails
        quality = 0
        Schema.sales.find({buyer: currentCustomerReturn.customer}).forEach(
          (sale)->
            Schema.saleDetails.find({sale: sale._id, product: returnDetail.product}).forEach(
              (saleDetail)-> quality += (saleDetail.quality - saleDetail.returnQuality)
            )
        )
        if quality < returnDetail.quality then throw 'So luong khong du.'

      for returnDetail in returnDetails
        saleDetails = []
        Schema.sales.find({buyer: currentCustomerReturn.customer}).forEach(
          (sale)->
            Schema.saleDetails.find({sale: sale._id, product: returnDetail.product}).forEach(
              (saleDetail)-> saleDetails.push saleDetail
            )
        )

        transactionQuality = 0
        for saleDetail in saleDetails
          requiredQuality = returnDetail.quality - transactionQuality
          availableReturnQuality = saleDetail.quality - saleDetail.returnQuality
          if availableReturnQuality > requiredQuality then takenQuality = requiredQuality
          else takenQuality = availableReturnQuality

          branchProduct = Schema.branchProductSummaries.findOne(saleDetail.branchProduct)
          updateOption = {}
          if branchProduct.basicDetailModeEnabled is false
            updateOption.availableQuality = takenQuality
            updateOption.inStockQuality   = takenQuality
            Schema.productDetails.update saleDetail.productDetail, $inc: updateOption

          updateOption.returnQualityByCustomer = takenQuality
          Schema.products.update branchProduct.product, $inc: updateOption
          Schema.branchProductSummaries.update branchProduct._id, $inc: updateOption

          Schema.saleDetails.update saleDetail._id, $inc:{returnQuality: takenQuality}
          Schema.sales.update saleDetail.sale, $set:{allowDelete: false}

          transactionQuality += takenQuality
          if transactionQuality == returnDetail.quality then break

      if customer = Schema.customers.findOne(currentCustomerReturn.customer)
        Schema.customers.update customer._id, $inc:{saleTotalCash: -totalReturnPrice, saleDebt: -totalReturnPrice}

        timeLineSale = Schema.sales.findOne({buyer: currentCustomerReturn.customer}, {sort: {'version.createdAt': -1}})
        Schema.returns.update currentCustomerReturn._id, $set: {
          timeLineSales: timeLineSale._id
          status: 2
          'version.createdAt': new Date()
          allowDelete: false
          beforeDebtBalance: customer.saleDebt
          debtBalanceChange: totalReturnPrice
          latestDebtBalance: customer.saleDebt - totalReturnPrice
        }
        MetroSummary.updateMyMetroSummaryBy(['createReturn'], currentCustomerReturn._id)
        Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
        Meteor.call 'customerToReturns', customer
        Meteor.call 'updateMetroSummaryBy', 'createReturnCustomer', currentCustomerReturn._id, currentCustomerReturn.merchant

    catch error
      throw new Meteor.Error('submitCustomerReturn', error)
