Apps.Merchant.merchantOptionsInit.push (scope) ->
  settings = scope.settings = {}

  settings.common = [
    display: "hệ thống"
    icon: "icon-cog-outline"
    template: "merchantSystemOptions"
    data: undefined
  ,
    display: "tài khoản"
    icon: "icon-group"
    template: "merchantAccountOptions"
    data: Session.get("myProfile")
  ,
    display: "ngôn ngữ"
    icon: "icon-location-1"
    template: "merchantLanguageOptions"
    data: undefined
  ,
    display: "trò chuyện"
    icon: "icon-chat-6"
    template: "merchantMessengerOptions"
    data: undefined
  ,
    display: "nhắc nhở"
    icon: "pink icon-globe-6"
    template: "merchantNotificationOptions"
    data: undefined
  ,
    display: "ghi chú"
    icon: "icon-code-outline"
    template: "merchantNoteOptions"
    data: undefined
  ]

  settings.printing = [
    display: "mẫu in"
    icon: "blue icon-clipboard"
    template: "merchantPrintDesigner"
    data: scope.myMerchantProfile
  ]

  settings.apps = [
    display: "bán hàng - giao hàng"
    icon: "orange icon-tags"
    template: "merchantSaleOptions"
    data: undefined
  ,
    display: "kho - nhập kho"
    icon: "green-sea icon-download-outline"
    template: "merchantImportOptions"
    data: undefined
  ,
    display: "khách hàng"
    icon: "lime icon-contacts"
    template: "merchantCustomerOptions"
    data: undefined
  ,
    display: "nhà cung cấp"
    icon: "carrot icon-anchor-outline"
    template: "merchantProviderOptions"
    data: undefined
  ]