customerManagerRoute =
  template: 'customerManager'
  waitOnDependency: 'customerManager'
  onBeforeAction: ->
    if @ready()
      Apps.setup(logics.customerManager, Apps.Merchant.customerManagerInit, 'customerManager')
      @next()
  data: ->
    logics.customerManager.reactiveRun()

    return {
      myCustomerAreas     : logics.customerManager.myCreateCustomerAreas
      areaSelectOptions   : logics.customerManager.areaSelectOptions
      genderSelectOptions : logics.customerManager.genderSelectOptions
      gridOptions         : logics.customerManager.gridOptions
      allowCreate         : logics.customerManager.allowCreate
    }

lemon.addRoute [customerManagerRoute], Apps.Merchant.RouterBase
