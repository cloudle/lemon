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
      if Session.get('currentDistributorReturn')?.distributor
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
      if currentDistributorReturn = Session.get('currentDistributorReturn')
        Meteor.call 'submitDistributorReturn', currentDistributorReturn