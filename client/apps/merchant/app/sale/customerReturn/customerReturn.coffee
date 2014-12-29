scope = logics.customerReturn

lemon.defineApp Template.customerReturn,
  currentCustomerReturn: -> Session.get('currentCustomerReturn')
  showCustomerSelect: -> if Session.get('currentCustomerReturn')?.returnMethods is 0 then true else false
  unitName: -> if @unit then @unit.unit else @product.basicUnit

  created: ->
    lemon.dependencies.resolve('customerReturn')

#  rendered: ->
#    if customer = Session.get('customerReturnCurrentCustomer')
#      Meteor.subscribe('customerReturnProductData', customer._id)

  events:
    "input .search-filter": (event, template) -> Session.set("customerReturnSearchFilter", template.ui.$searchFilter.val())

    "click .addReturnDetail": (event, template) ->
      if Session.get('currentCustomerReturn')
        option =
          return            : Session.get('currentCustomerReturn')._id
          product           : @product._id
          conversionQuality : 1
          unitReturnQuality : 1
          unitReturnsPrice  : @product.price
          price             : @product.price
          discountCash      : 0
          discountPercent   : 0

        if @unit
          option.unit = @unit._id
          option.conversionQuality = @unit.conversionQuality
          option.unitReturnsPrice  = @unit.price

        option.returnQuality = option.conversionQuality
        option.finalPrice    = (option.unitReturnQuality * option.unitReturnsPrice) - option.discountCash

        Schema.returnDetails.insert option
        Schema.returns.update Session.get('currentCustomerReturn')._id, $inc:{
          debtBalanceChange: option.finalPrice
          totalPrice  : option.finalPrice + option.discountCash
          finallyPrice: option.finalPrice
        }

    "click .submitReturn": (event, template) ->
      try
        currentCustomerReturn = Session.get('currentCustomerReturn')
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

            product = Schema.products.findOne(saleDetail.product)
            if product.basicDetailModeEnabled is false
              Schema.products.update saleDetail.product, $inc:{
                availableQuality: takenQuality
                inStockQuality: takenQuality
                salesQuality: -takenQuality
              }
              Schema.productDetails.update saleDetail.productDetail, $inc:{
                availableQuality: takenQuality
                inStockQuality: takenQuality
              }
            Schema.saleDetails.update saleDetail._id, $inc:{returnQuality: takenQuality}
            Schema.sales.update saleDetail.sale, $set:{allowDelete: false}

            transactionQuality += takenQuality
            if transactionQuality == returnDetail.quality then break

        customer = Schema.customers.findOne(currentCustomerReturn.customer)
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
        Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'

        if customer = Schema.customers.findOne(currentCustomerReturn.customer)
          Meteor.call 'customerToReturns', customer, Session.get('myProfile')
      catch error
        console.log error