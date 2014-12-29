destroyReturnAndDetail = (scope, returnId)->
  if currentCustomerReturn = Schema.returns.findOne(returnId)
    Schema.returns.remove(currentCustomerReturn._id)
    for returnDetail in Schema.returnDetails.find({return: currentCustomerReturn._id}).fetch()
      Schema.returnDetails.remove(returnDetail._id)
    Schema.returns.find({creator:currentCustomerReturn.creator, status: 0, returnMethods: 0}).count()
  else
    -1

createReturnAndSelected = ()->
  if profile = Session.get('myProfile')
    returnOption =
      merchant: profile.currentMerchant
      warehouse: profile.currentWarehouse
      creator: profile.user
      returnCode: 'TH'
      discountCash: 0
      discountPercent: 0
      totalPrice: 0
      finallyPrice: 0
      status: 0
      returnMethods: 0
      beforeDebtBalance: 0
      debtBalanceChange: 0
      latestDebtBalance: 0
    returnOption._id = Schema.returns.insert returnOption
    UserSession.set('currentCustomerReturn', returnOption._id)
    Session.set('currentCustomerReturn', returnOption)


Apps.Merchant.customerReturnInit.push (scope) ->
  scope.tabOptions =
    source: Schema.returns.find({status: 0, returnMethods: 0})
    currentSource: 'currentCustomerReturn'
    caption: 'tabDisplay'
    key: '_id'
    createAction: -> createReturnAndSelected()
    destroyAction: (instance) -> destroyReturnAndDetail(scope, instance._id)
    navigateAction: (instance) ->
      if instance
        UserSession.set('currentCustomerReturn', instance._id)
        Session.set('currentCustomerReturn', instance)
        Meteor.subscribe('customerReturnData')