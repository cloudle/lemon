Apps.Merchant.merchantOptionsInit.push (scope) ->
  settings = scope.settings = {}

  settings.common = [
    display: "doanh nghiệp"
    icon: "icon-location-1"
    template: "merchantBusinessOptions"
  ,
    display: "tài khoản"
    icon: "icon-location-1"
    template: "merchantAccountOptions"
    data: undefined
  ,
    display: "trò chuyện"
    icon: "icon-location-1"
    template: "merchantMessengerOptions"
  ,
    display: "nhắc nhở"
    icon: "icon-location-1"
    template: "merchantNotificationOptions"
  ]

  settings.printing = [
    display: "phiếu bán hàng"
    icon: "icon-location-1"
    template: "merchantPrintDesigner"
    data: scope.myMerchantProfile
  ,
    display: "phiếu nhập kho"
    icon: "icon-location-1"
    template: "merchantPrintDesigner2"
  ]

  settings.display = [

  ]



