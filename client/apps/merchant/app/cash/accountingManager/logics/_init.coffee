logics.accountingManager = {}
Apps.Merchant.accountingManagerInit = []
Apps.Merchant.accountingManagerReload = []

Apps.Merchant.accountingManagerInit.push (scope) ->
  date = new Date();
  firstDay = new Date(date.getFullYear(), date.getMonth(), 15);
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  Session.set('accountingFilterStartDate', firstDay)
  Session.set('accountingFilterToDate', lastDay)

Apps.Merchant.accountingManagerReload.push (scope) ->

logics.accountingManager.reactiveRun = ->
  if Session.get('accountingFilterStartDate') and Session.get('accountingFilterToDate') and Session.get('myProfile')
    logics.accountingManager.availableAccounting = Sale.findAccountingDetails(
      Session.get('accountingFilterStartDate'),
      Session.get('accountingFilterToDate'),
      Session.get('myProfile').currentWarehouse
    )
