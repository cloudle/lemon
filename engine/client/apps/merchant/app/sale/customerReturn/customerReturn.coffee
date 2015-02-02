scope = logics.customerReturn

lemon.defineApp Template.customerReturn,
  currentCustomerReturn: -> Session.get('currentCustomerReturn')
  showCustomerSelect: -> if Session.get('currentCustomerReturn')?.returnMethods is 0 then true else false
  unitName: -> if @unit then @unit.unit else @product.basicUnit
  allowSuccessReturn: -> if Session.get('currentCustomerReturn')?.customer then '' else 'disabled'

  created: ->
    lemon.dependencies.resolve('customerReturn')

#  rendered: ->
#    if customer = Session.get('customerReturnCurrentCustomer')
#      Meteor.subscribe('customerReturnProductData', customer._id)

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("customerReturnSearchFilter", template.ui.$searchFilter.val())
      , "currentCustomerReturnSearchProduct"


    "click .addReturnDetail": (event, template) ->
      productId     = @product._id
      productUnitId = @unit._id if @unit
      currentReturn = Session.get('currentCustomerReturn')

      if currentReturn?.customer and productId
        product       = Schema.products.findOne(productId)
        branchProduct = Schema.branchProductSummaries.findOne({product: product._id, merchant: currentReturn.merchant})
        product.price = branchProduct.price if branchProduct.price

        if productUnitId
          productUnit       = Schema.productUnits.findOne(productUnitId)
          branchProductUnit = Schema.branchProductUnits.findOne({productUnit: productUnit._id, merchant: currentReturn.merchant})
          productUnit.price = branchProductUnit.price if branchProductUnit.price

          if productUnit.buildInProductUnit
            buildInProductUnit = Schema.buildInProductUnits.findOne(productUnit.buildInProductUnit)
            productUnit.conversionQuality = buildInProductUnit.conversionQuality

        option =
          return            : currentReturn._id
          product           : productId
          branchProduct     : branchProduct._id
          conversionQuality : 1
          unitReturnQuality : 1
          unitReturnsPrice  : product.price
          price             : product.price
          discountCash      : 0
          discountPercent   : 0

        if productUnitId
          option.unit = productUnitId
          option.conversionQuality = productUnit.conversionQuality
          option.unitReturnsPrice  = productUnit.price

        option.returnQuality = option.conversionQuality
        option.finalPrice    = (option.unitReturnQuality * option.unitReturnsPrice) - option.discountCash

        Schema.returnDetails.insert option
        Schema.returns.update currentReturn._id, $inc:{
          debtBalanceChange: option.finalPrice
          totalPrice       : option.finalPrice + option.discountCash
          finallyPrice     : option.finalPrice
        }

    "click .submitReturn": (event, template) ->
      if currentCustomerReturn = Session.get('currentCustomerReturn')
        Meteor.call 'submitCustomerReturn', currentCustomerReturn, (error, result) ->
          if error
            console.log error.reason
            console.log error.message