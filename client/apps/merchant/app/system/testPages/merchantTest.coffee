lemon.dependencies.add 'merchantTest', ['merchantTestDep',
                                        'myMerchantProfiles']


merchantTestRoute =
  template: 'merchantTest',
  waitOnDependency: 'merchantTest'

lemon.addRoute [merchantTestRoute], Apps.Merchant.RouterBase