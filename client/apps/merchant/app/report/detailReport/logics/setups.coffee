Apps.Merchant.merchantReportInit.push (scope) ->
  Meteor.subscribe('merchantReportData')

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