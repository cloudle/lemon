destroyReturnAndDetail = (scope, returnId)->
  if currentCustomerReturn = Schema.returns.findOne(returnId)
    for returnDetail in Schema.returnDetails.find({return: currentCustomerReturn._id}).fetch()
      Schema.returnDetails.remove(returnDetail._id)
    Schema.returns.remove(currentCustomerReturn._id)
    Schema.returns.find({creator:currentCustomerReturn.creator}).count()
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
      comment: 'Tra Hang'
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
    source: Schema.returns.find({status: 0})
    currentSource: 'currentCustomerReturn'
    caption: 'comment'
    key: '_id'
    createAction: -> createReturnAndSelected()
    destroyAction: (instance) -> destroyReturnAndDetail(scope, instance._id)
    navigateAction: (instance) ->
      UserSession.set('currentCustomerReturn', instance._id)
      Session.set('currentCustomerReturn', instance)
      Meteor.subscribe('customerReturnData')