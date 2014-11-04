logics.billManager = {}
Apps.Merchant.billManagerInit = []

Apps.Merchant.billManagerInit.push (scope) ->
  date = new Date();
  firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  Session.set('billFilterStartDate', firstDay)
  Session.set('billFilterToDate', lastDay)

logics.billManager.reactiveRun = ->
  if Session.get('billFilterStartDate') and Session.get('billFilterToDate') and Session.get('myProfile')
    logics.billManager.availableBills = Sale.findBillDetails(
      Session.get('billFilterStartDate'),
      Session.get('billFilterToDate'),
      Session.get('myProfile').currentWarehouse
    )

  if Session.get('currentBillManagerSale')
    logics.billManager.currentSaleDetails = Schema.saleDetails.find {sale: Session.get('currentBillManagerSale')._id}
