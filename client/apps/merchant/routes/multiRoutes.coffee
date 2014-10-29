merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }
_.extend(merchantDevRoute, Merchant.merchantRouteBase)

metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Merchant.Subscriber)
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(metroSummaryRoute, Merchant.merchantRouteBase)

importRoute =
  layoutTemplate: 'merchantLayout',
  template: 'import',
  fastRender: true,
  waitOn: -> lemon.dependencies.resolve('warehouseImport')
  data: ->
    logics.sales.syncMyProfile()
    logics.sales.syncMyOption()
    logics.sales.syncMySession()

    logics.import.syncCurrentWarehouse()
    logics.import.syncCurrentImport()
    logics.import.syncCurrentImportDetails()
    logics.import.syncCurrentProductAndProvider()
    logics.import.syncImportInfo()

    return{
    productSelectOptions  : logics.import.importProductSelectOptions
    providerSelectOptions : logics.import.importProviderSelectOptions

    #iSpinEdit
    qualityOptions: logics.import.qualityOptions

    }
_.extend(importRoute, Merchant.merchantRouteBase)



lemon.addRoute [merchantDevRoute, metroSummaryRoute, importRoute]