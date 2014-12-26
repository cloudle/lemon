scope = logics.distributorReturn

lemon.defineApp Template.distributorReturn,
  currentDistributorReturn: -> Session.get('currentDistributorReturn')
  showCustomerSelect: -> if Session.get('currentDistributorReturn')?.returnMethods is 0 then true else false
  unitName: -> if @unit then @unit.unit else @product.basicUnit

  created: ->
    lemon.dependencies.resolve('distributorReturn')

#  rendered: ->
#    if customer = Session.get('customerReturnCurrentCustomer')
#      Meteor.subscribe('customerReturnProductData', customer._id)

  events:
    "input .search-filter": (event, template) -> Session.set("distributorReturnSearchFilter", template.ui.$searchFilter.val())

    "click .addReturnDetail": (event, template) ->
      if Session.get('currentDistributorReturn')
        option =
          return            : Session.get('currentDistributorReturn')._id
          product           : @product._id
          conversionQuality : 1
          unitReturnQuality : 1
          unitReturnsPrice  : @product.importPrice
          price             : @product.price
          discountCash      : 0
          discountPercent   : 0

        if @unit
          option.unit = @unit._id
          option.conversionQuality = @unit.conversionQuality
          option.unitReturnsPrice  = @unit.importPrice

        option.returnQuality = option.conversionQuality
        option.finalPrice    = (option.unitReturnQuality * option.unitReturnsPrice) - option.discountCash

        Schema.returnDetails.insert option
        Schema.returns.update Session.get('currentDistributorReturn')._id, $inc:{
          debtBalanceChange: option.finalPrice
          totalPrice  : option.finalPrice + option.discountCash
          finallyPrice: option.finalPrice
        }

    "click .submitReturn": (event, template) ->
      try
        currentDistributorReturn = Session.get('currentDistributorReturn')
        returnDetails = Schema.returnDetails.find({return: currentDistributorReturn._id}).fetch()
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
          Schema.productDetails.find({
            distributor: currentDistributorReturn.distributor
            product: returnDetail.product
            availableQuality: {$gt:0}
          }).forEach((productDetail)-> quality += productDetail.availableQuality)
          if quality < returnDetail.quality then throw 'So luong khong du.'

        for returnDetail in returnDetails
          productDetails = Schema.productDetails.find({
            distributor: currentDistributorReturn.distributor
            product: returnDetail.product
            availableQuality: {$gt:0}
          }).fetch()

          transactionQuality = 0
          for productDetail in productDetails
            requiredQuality = returnDetail.quality - transactionQuality
            if productDetail.availableQuality > requiredQuality then takenQuality = requiredQuality
            else takenQuality = productDetail.availableQuality

            Schema.productDetails.update productDetail._id, $inc:{
              availableQuality: -takenQuality
              inStockQuality: -takenQuality
              importPrice: -takenQuality
            }
            Schema.products.update productDetail.product  , $inc:{
              availableQuality: -takenQuality
              inStockQuality: -takenQuality
              totalQuality: -takenQuality
            }

            transactionQuality += takenQuality
            if transactionQuality == returnDetail.quality then break

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

        if distributor = Schema.distributors.findOne(currentDistributorReturn.distributor)
          Meteor.call 'distributorToReturns', distributor, Session.get('myProfile')
      catch error
        console.log error