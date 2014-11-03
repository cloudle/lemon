logics.returns = {}
Apps.Merchant.returnsInit = []

Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.availableSales = Sale.findAvailableReturn(Session.get('myProfile'))


logics.returns.reactiveRun = ->
  if Session.get('mySession')
    logics.returns.currentSale = Schema.sales.findOne(Session.get('mySession').currentSale)

  if logics.returns.currentSale
    logics.returns.currentReturn        = Schema.returns.findOne({sale: logics.returns.currentSale._id, status: {$ne: 2}})
    logics.returns.availableSaleDetails = Schema.saleDetails.find({sale: logics.returns.currentSale._id})
  else
    logics.returns.availableSaleDetails = []

  if logics.returns.currentReturn
    logics.returns.availableReturnDetails = Schema.returnDetails.find({return: logics.returns.currentReturn})
  else
    logics.returns.availableReturnDetails = []


  logics.returns.currentMaxQualityReturn = 0 #returnQuality()
