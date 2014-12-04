Apps.Merchant.merchantReportInit.push (scope) ->
  Session.setDefault "merchantReportBranchSelection",
    Schema.merchants.findOne Session.get("myProfile").parentMerchant

  scope.groupReportByDay = [
    _id: ''
    display: 'Trong ngày'
  ,
    _id: ''
    display: 'Trong tuần'
  ,
    _id: ''
    display: 'Trong tháng'
  ]