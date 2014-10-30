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

    Session.set('currentImport', logics.import.currentImport)

    return{
    productSelectOptions  : logics.import.importProductSelectOptions
    providerSelectOptions : logics.import.importProviderSelectOptions

    tabOptions  : logics.import.tabOptions

    #iSpinEdit
    qualityOptions    : logics.import.qualityOptions
    importPriceOptions: logics.import.importPriceOptions

    }
_.extend(importRoute, Apps.Merchant.RouterBase)


lemon.addRoute [importRoute]