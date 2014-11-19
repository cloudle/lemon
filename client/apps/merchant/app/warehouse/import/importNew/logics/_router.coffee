importRoute =
  template: 'import',
  waitOnDependency: 'importManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.import, Apps.Merchant.importInit, 'import')
      @next()
  data: ->
    logics.import.reactiveRun()

    return{
      showCreateDetail: logics.import.showCreateDetail
      showSubmit      : logics.import.showSubmit
      showFinish      : logics.import.showFinish
      showEdit        : logics.import.showEdit
      hidePriceSale   : logics.import.hidePriceSale

      myCreateProduct     : logics.import.myCreateProduct
      myCreateProvider    : logics.import.myCreateProvider
      myCreateDistributor : logics.import.myCreateDistributor

      tabOptions          : logics.import.tabOptions
      importDetailOptions : logics.import.importDetailOptions

      currentImport            : logics.import.currentImport
      productSelectOptions     : logics.import.productSelectOptions
      providerSelectOptions    : logics.import.providerSelectOptions
      distributorSelectOptions : logics.import.distributorSelectOptions
      timeUseSelectOptions     : logics.import.timeUseSelectOptions

      qualityOptions    : logics.import.qualityOptions
      importPriceOptions: logics.import.importPriceOptions
      salePriceOptions  : logics.import.salePriceOptions
    }

lemon.addRoute [importRoute], Apps.Merchant.RouterBase