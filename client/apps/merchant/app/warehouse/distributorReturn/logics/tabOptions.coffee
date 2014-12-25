destroyReturnAndDetail = (scope, returnId)->
  if currentDistributorReturn = Schema.returns.findOne(returnId)
    for returnDetail in Schema.returnDetails.find({return: currentDistributorReturn._id}).fetch()
      Schema.returnDetails.remove(returnDetail._id)
    Schema.returns.remove(currentDistributorReturn._id)
    Schema.returns.find({creator:currentDistributorReturn.creator}).count()
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
      returnMethods: 1
      beforeDebtBalance: 0
      debtBalanceChange: 0
      latestDebtBalance: 0
    returnOption._id = Schema.returns.insert returnOption
    UserSession.set('currentDistributorReturn', returnOption._id)
    Session.set('currentDistributorReturn', returnOption)


Apps.Merchant.distributorReturnInit.push (scope) ->
  scope.tabOptions =
    source: Schema.returns.find({status: 0, returnMethods: 1})
    currentSource: 'currentDistributorReturn'
    caption: 'tabDisplay'
    key: '_id'
    createAction: -> createReturnAndSelected()
    destroyAction: (instance) -> destroyReturnAndDetail(scope, instance._id)
    navigateAction: (instance) ->
      UserSession.set('currentDistributorReturn', instance._id)
      Session.set('currentDistributorReturn', instance)
      Meteor.subscribe('distributorReturnData')