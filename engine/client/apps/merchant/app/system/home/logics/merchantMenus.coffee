Apps.Merchant.homeInit.push (scope) ->
  appMenus = scope.appMenus = [
    display: "hệ thống"
    icon: "pomegranate icon-wrench-outline"
    app: "merchantOptions"
  ,
    display: "cửa hàng"
    icon: "carrot icon-location-1"
    app: "staffManagement"
  ,
    display: "nhật ký"
    icon: "lime icon-history"
    app: "staffManagement"
  ,
    display: "nhân sự"
    icon: "blue icon-users-outline"
    app: "staffManagement"
  ,
    display: "phân quyền"
    icon: "wisteria icon-key-outline"
    app: "roleManagement"
  ]
