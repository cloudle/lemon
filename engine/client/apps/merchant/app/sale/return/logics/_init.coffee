logics.returns = {}
Apps.Merchant.returnsInit = []


Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.availableSales = Sale.findAvailableReturn(Session.get('myProfile'))


logics.returns.reactiveRun = ->
  if Session.get('mySession')
    logics.returns.currentSale   = Schema.sales.findOne(Session.get('mySession').currentSale)
    logics.returns.currentReturn = Schema.returns.findOne({sale: Session.get('mySession').currentSale, status: {$ne: 2}})

  if logics.returns.currentSale
    Session.set('currentSale', logics.returns.currentSale)
    Meteor.subscribe('saleDetailAndProductAndReturn',logics.returns.currentSale._id)
    logics.returns.availableSaleDetails = Schema.saleDetails.find({sale: logics.returns.currentSale._id})
  else
    Session.set('currentSale')

  if logics.returns.currentReturn
    Session.set('currentReturn', logics.returns.currentReturn)
    Meteor.subscribe('returnDetails',logics.returns.currentReturn._id)
    logics.returns.availableReturnDetails = Schema.returnDetails.find({return: logics.returns.currentReturn._id})
  else
    logics.returns.availableReturnDetails = Schema.returnDetails.find({return: 'null'})

