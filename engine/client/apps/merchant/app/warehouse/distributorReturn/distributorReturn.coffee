scope = logics.distributorReturn

lemon.defineApp Template.distributorReturn,
  currentDistributorReturn: -> Session.get('currentDistributorReturn')
  showCustomerSelect: -> if Session.get('currentDistributorReturn')?.returnMethods is 0 then true else false
  unitName: -> if @unit then @unit.unit else @product.basicUnit
  allowSuccessReturn: -> if Session.get('currentDistributorReturn')?.distributor then '' else 'disabled'

  created: ->
    lemon.dependencies.resolve('distributorReturn')

#  rendered: ->
#    if customer = Session.get('customerReturnCurrentCustomer')
#      Meteor.subscribe('customerReturnProductData', customer._id)

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("distributorReturnSearchFilter", template.ui.$searchFilter.val())
      , "currentDistributorReturnSearchProduct"


    "click .addReturnDetail": (event, template) ->
      productId     = @product._id
      productUnitId = @unit._id if @unit
      currentReturn = Session.get('currentDistributorReturn')

      if currentReturn?.distributor and productId
        product       = Schema.products.findOne(productId)
        branchProduct = Schema.branchProductSummaries.findOne({product: product._id, merchant: currentReturn.merchant})
        product.importPrice = branchProduct.importPrice if branchProduct.importPrice

        if productUnitId
          productUnit       = Schema.productUnits.findOne(productUnitId)
          branchProductUnit = Schema.branchProductUnits.findOne({productUnit: productUnit._id, merchant: currentReturn.merchant})
          productUnit.importPrice = branchProductUnit.importPrice if branchProductUnit.importPrice

          if productUnit.buildInProductUnit
            buildInProductUnit = Schema.buildInProductUnits.findOne(productUnit.buildInProductUnit)
            productUnit.conversionQuality = buildInProductUnit.conversionQuality

        option =
          return            : currentReturn._id
          product           : productId
          branchProduct     : branchProduct._id
          conversionQuality : 1
          unitReturnQuality : 1
          unitReturnsPrice  : product.importPrice
          price             : product.importPrice
          discountCash      : 0
          discountPercent   : 0

        if productUnit
          option.unit = productUnit._id
          option.conversionQuality = productUnit.conversionQuality
          option.unitReturnsPrice  = productUnit.importPrice

        option.returnQuality = option.conversionQuality
        option.finalPrice    = (option.unitReturnQuality * option.unitReturnsPrice) - option.discountCash

        Schema.returnDetails.insert option
        Schema.returns.update currentReturn._id, $inc:{
          debtBalanceChange: option.finalPrice
          totalPrice       : option.finalPrice + option.discountCash
          finallyPrice     : option.finalPrice
        }

    "click .submitReturn": (event, template) ->
      if currentDistributorReturn = Session.get('currentDistributorReturn')
        Meteor.call 'submitDistributorReturn', currentDistributorReturn