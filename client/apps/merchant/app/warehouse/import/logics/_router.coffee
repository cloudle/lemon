importRoute =
  template: 'import',
  waitOnDependency: 'warehouseImport'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.import, Apps.Merchant.importInit, 'import')
      @next()
  data: ->
    logics.import.reactiveRun()

    return{
      creatorName: Session.get('myProfile')?.fullName

      hideAddDetail     : logics.import.hideAddDetail
      hidePrice         : logics.import.hidePrice
      hideFinishImport  : logics.import.hideFinishImport
      hideEditImport    : logics.import.hideEditImport
      hideSubmitImport  : logics.import.hideSubmitImport

      myCreateProduct : logics.import.myCreateProduct
      myCreateProvider: logics.import.myCreateProvider

      tabOptions          : logics.import.tabOptions
      importDetailOptions : logics.import.importDetailOptions

      currentImport         : logics.import.currentImport
      productSelectOptions  : logics.import.productSelectOptions
      providerSelectOptions : logics.import.providerSelectOptions
      timeUseSelectOptions  : logics.import.timeUseSelectOptions

      qualityOptions    : logics.import.qualityOptions
      importPriceOptions: logics.import.importPriceOptions
      salePriceOptions  : logics.import.salePriceOptions
    }

lemon.addRoute [importRoute], Apps.Merchant.RouterBase