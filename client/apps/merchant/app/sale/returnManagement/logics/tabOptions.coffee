destroyReturnAndDetail = (scope, returnId)->
  if currentReturn = Schema.returns.findOne(returnId)
    for returnDetail in Schema.returnDetails.find({return: currentReturn._id}).fetch()
      Schema.returnDetails.remove(returnDetail._id)
    Schema.returns.remove(currentReturn._id)
    Schema.returns.find({creator:currentReturn.creator}).count()
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
    UserSession.set('currentReturn', returnOption._id)
    Session.set('currentReturn', returnOption)


Apps.Merchant.returnManagementInit.push (scope) ->
  scope.tabOptions =
    source: Schema.returns.find({status: 0})
    currentSource: 'currentReturn'
    caption: 'comment'
    key: '_id'
    createAction: -> createReturnAndSelected()
    destroyAction: (instance) -> destroyReturnAndDetail(scope, instance._id)
    navigateAction: (instance) ->
      UserSession.set('currentReturn', instance._id)
      Session.set('currentReturn', instance)
      if instance.customer then Meteor.subscribe('returnManagementData')