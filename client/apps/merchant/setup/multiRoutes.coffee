merchantDevRoute =
  template: 'merchantDev',
  waitOn: -> lemon.dependencies.resolve('essentials')
  data: -> { System: System.findOne({}) }
_.extend(merchantDevRoute, Apps.Merchant.RouterBase)

metroSummaryRoute =
  template: 'merchantHome'
  path: 'merchant'
  waitOn: -> lemon.dependencies.resolve('merchantHome', Apps.MerchantSubscriber)
  data: -> {Summary: MetroSummary.findOne({})}
_.extend(metroSummaryRoute, Apps.Merchant.RouterBase)

importRoute =
  template: 'import',
  fastRender: true,
  waitOn: -> lemon.dependencies.resolve('warehouseImport', Apps.MerchantSubscriber)
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
_.extend(importRoute, Apps.Merchant.RouterBase)

lemon.addRoute [merchantDevRoute, metroSummaryRoute, importRoute]