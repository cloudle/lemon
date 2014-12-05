scope = logics.import

importRoute =
  template: 'import',
  waitOnDependency: 'importManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Merchant.importInit, 'import')
      Session.set "currentAppInfo",
        name: "nhập kho"
      @next()
  data: ->
    Apps.setup(scope, Apps.Merchant.importReactive)

    return{
      showCreateDetail: scope.showCreateDetail
      showSubmit      : scope.showSubmit
      showFinish      : scope.showFinish
      showEdit        : scope.showEdit
      hidePriceSale   : scope.hidePriceSale

      myCreateProduct     : scope.myCreateProduct
      myCreateProvider    : scope.myCreateProvider
      myCreateDistributor : scope.myCreateDistributor

      tabOptions          : scope.tabOptions
      importDetailOptions : scope.importDetailOptions

      currentImport            : scope.currentImport
      productSelectOptions     : scope.productSelectOptions
      providerSelectOptions    : scope.providerSelectOptions
      distributorSelectOptions : scope.distributorSelectOptions
      timeUseSelectOptions     : scope.timeUseSelectOptions

      qualityOptions    : scope.qualityOptions
      importPriceOptions: scope.importPriceOptions
      salePriceOptions  : scope.salePriceOptions

      managedProductList: scope.managedProductList
    }

lemon.addRoute [importRoute], Apps.Merchant.RouterBase