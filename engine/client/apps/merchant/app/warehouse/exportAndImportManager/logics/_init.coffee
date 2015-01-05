logics.exportAndImportManager = {}
Apps.Merchant.exportAndImportManagerInit = []

Apps.Merchant.exportAndImportManagerInit.push (scope) ->
  date = new Date();
  firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
  Session.set('exportAndImportFilterStartDate', firstDay)
  Session.set('exportAndImportFilterToDate', lastDay)

logics.exportAndImportManager.reactiveRun = ->
  if Session.get('exportAndImportFilterStartDate') and Session.get('exportAndImportFilterToDate') and Session.get('myProfile')
    logics.exportAndImportManager.availableBills = Sale.findExportAndImport(
      Session.get('exportAndImportFilterStartDate'),
      Session.get('exportAndImportFilterToDate'),
      Session.get('myProfile').currentWarehouse
    )

