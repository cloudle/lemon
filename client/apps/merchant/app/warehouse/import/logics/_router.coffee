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
      hideAddImportDetail:  "display: none" if Session.get('currentImport')?.finish == true
      hidePrice:  "display: none" unless Session.get('currentImport')?.currentPrice >= 0
      hideFinishImport: "display: none" if Session.get('currentImport')?.finish == true || !(Session.get('currentImportDetails')?.length > 0)
      hideEditImport: "display: none" if Session.get('currentImport')?.finish == false
      hideSubmitImport: "display: none" if Session.get('currentImport')?.submitted == true


      currentImport         : logics.import.currentImport
      productSelectOptions  : logics.import.productSelectOptions
      providerSelectOptions : logics.import.providerSelectOptions

      tabOptions          : logics.import.tabOptions
      importDetailOptions : logics.import.importDetailOptions

      qualityOptions    : logics.import.qualityOptions
      importPriceOptions: logics.import.importPriceOptions
      salePriceOptions  : logics.import.salePriceOptions
    }

lemon.addRoute [importRoute], Apps.Merchant.RouterBase, Apps.MerchantSubscriber