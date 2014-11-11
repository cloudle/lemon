scope = logics.merchantWizard

lemon.addRoute
  path: '/merchantWizard'
  layoutTemplate: 'subHomeLayout'
  waitOnDependency: 'merchantPurchase'
  onBeforeAction: ->
    if @ready()
      Apps.setup(scope, Apps.Home.merchantWizardInit, 'merchantWizard')
      @next()
  data: ->
    Apps.setup(scope, Apps.Home.merchantWizardReactive)

    return {
      trialPackageOption: scope.trialPackageOption
      oneYearsPackageOption: scope.oneYearsPackageOption
      threeYearsPackageOption: scope.threeYearsPackageOption
      fiveYearsPackageOption: scope.fiveYearsPackageOption
      purchase: scope.purchase
    }