destroyReturnAndDetail = (scope, returnId)->
  if currentDistributorReturn = Schema.returns.findOne(returnId)
    for returnDetail in Schema.returnDetails.find({return: currentDistributorReturn._id}).fetch()
      Schema.returnDetails.remove(returnDetail._id)
    Schema.returns.remove(currentDistributorReturn._id)
    countReturn = Schema.returns.find({creator: Session.get('myProfile').user, status: 0, returnMethods: 1}).count()
    console.log countReturn
    countReturn
  else
    -1

createReturnAndSelected = ()->
  if profile = Session.get('myProfile')
    returnOption =
      merchant: profile.currentMerchant
      warehouse: profile.currentWarehouse
      creator: profile.user
      returnCode: 'TH-NCC'
      discountCash: 0
      discountPercent: 0
      totalPrice: 0
      finallyPrice: 0
      status: 0
      returnMethods: 1
      beforeDebtBalance: 0
      debtBalanceChange: 0
      latestDebtBalance: 0
      tabDisplay: 'Trả Hàng Nhập'

    returnOption._id = Schema.returns.insert returnOption
    UserSession.set('currentDistributorReturn', returnOption._id)
    Session.set('currentDistributorReturn', returnOption)


Apps.Merchant.distributorReturnInit.push (scope) ->
  if Session.get('myProfile')
    scope.tabOptions =
      source: Schema.returns.find({creator: Session.get('myProfile').user, status: 0, returnMethods: 1})
      currentSource: 'currentDistributorReturn'
      caption: 'tabDisplay'
      key: '_id'
      createAction: -> createReturnAndSelected()
      destroyAction: (instance) -> destroyReturnAndDetail(scope, instance._id)
      navigateAction: (instance) ->
        if instance
          UserSession.set('currentDistributorReturn', instance._id)
          Session.set('currentDistributorReturn', instance)
          Session.set("currentDistributorReturnComment", instance.comment)
          Meteor.subscribe('distributorReturnData')