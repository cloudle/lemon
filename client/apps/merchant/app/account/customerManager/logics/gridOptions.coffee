Apps.Merchant.customerManagerInit.push ->
  logics.customerManager.gridOptions =
    itemTemplate: 'customerThumbnail'
    reactiveSourceGetter: -> Schema.users.find {parentMerchant: Apps.myProfile.parentMerchant}
    wrapperClasses: 'detail-grid row'