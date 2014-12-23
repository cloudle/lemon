destroyReturnAndDetail = (scope, returnId)->
  if currentReturn = Schema.returns.findOne(returnId)
    for returnDetail in Schema.returnDetails.find({return: currentReturn._id}).fetch()
      Schema.returnDetails.remove(returnDetail._id)
    Schema.returns.remove(currentReturn._id)

    Schema.returns.find({creator:currentReturn.creator}).count()
  else
    -1

Apps.Merchant.returnManagementInit.push (scope) ->
  scope.tabOptions =
    source: Schema.returns.find({status: 0})
    currentSource: 'currentReturn'
    caption: 'comment'
    key: '_id'
    createAction: -> #scope.createNewreturnAndSelected()
    destroyAction: (instance) -> destroyReturnAndDetail(scope, instance._id)
    navigateAction: (instance) ->
      UserSession.set('currentReturn', instance._id)
      Session.set('currentReturn', instance)
      Meteor.subscribe('returnManagementData')