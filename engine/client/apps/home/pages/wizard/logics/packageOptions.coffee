Apps.Home.merchantWizardInit.push (scope) ->
  scope.trialPackageOption =
    packageClass: 'free'
    title: 'TRẢI NGHIỆM'
    titlePrice: '0'
    titleDuration: '14 NGÀY'
    price: 0
    duration: 14
    years: 0
    hint: 'free hint'
    accountLim: 5
    branchLim: 1
    warehouseLim: 1
    footer: 'free footer'

  scope.oneYearsPackageOption =
    packageClass: 'basic'
    title: 'KHỞI ĐỘNG'
    titlePrice: '11 triệu'
    titleDuration: '1 NĂM'
    price: 11000000
    duration: 365
    years: 1
    hint: 'basic hint'
    accountLim: 10
    branchLim: 1
    warehouseLim: 1
    extendAccountPrice: 60000
    extendBranchPrice: 4500000
    extendWarehousePrice: 600000
    footer: 'basic footer'

  scope.threeYearsPackageOption =
    packageClass: 'premium'
    title: 'TĂNG TRƯỞNG'
    titlePrice: '30 triệu'
    titleDuration: '3 NĂM'
    price: 30000000
    duration: 365*3
    years: 3
    hint: 'premium hint'
    accountLim: 15
    branchLim: 1
    warehouseLim: 1
    extendAccountPrice: 60000
    extendBranchPrice: 4500000
    extendWarehousePrice: 600000
    footer: 'premium footer'

  scope.fiveYearsPackageOption =
    packageClass: 'advance'
    title: 'BỀN VỮNG'
    titlePrice: '45 triệu'
    titleDuration: '5 NĂM'
    price: 45000000
    duration: 365*5
    years: 5
    hint: 'advance hint'
    accountLim: 20
    branchLim: 2
    warehouseLim: 2
    extendAccountPrice: 60000
    extendBranchPrice: 4500000
    extendWarehousePrice: 600000
    footer: 'advance footer'

  Session.set('currentMerchantPackage', scope.trialPackageOption)
  Session.set('wizardAccountPlus', 0)
  Session.set('wizardBranchPlus', 0)
  Session.set('wizardWarehousePlus', 0)