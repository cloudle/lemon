logics.staffManagement = {}
Apps.Merchant.staffManagementInit = []
Apps.Merchant.staffManagementReactive = []

Apps.Merchant.staffManagementReactive.push (scope) ->
#  allowCreate = if Session.get('allowCreateNewStaff') then '' else 'disabled'
#  scope.allowCreate = allowCreate

  if staffId = Session.get("mySession")?.currentStaffManagementSelection
    Session.set("staffManagementCurrentStaff", Schema.staffs.findOne(staffId))

  if staff = Session.get("staffManagementCurrentStaff")
    maxRecords = Session.get("staffManagementDataMaxCurrentRecords")
    countRecords = Schema.customSales.find({buyer: staff._id}).count()
    countRecords += Schema.sales.find({buyer: staff._id}).count() if staff.customSaleModeEnabled is false
    Session.set("showExpandSaleAndCustomSale", (maxRecords is countRecords))


    if latestCustomSale = Schema.customSales.findOne({buyer: staff._id}, {sort: {debtDate: -1}})
      if latestTransaction = Schema.transactions.findOne({latestSale: latestCustomSale._id}, {sort: {debtDate: -1}})
        $("[name=paidDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
      else
        $("[name=paidDate]").val(moment(latestCustomSale.debtDate).format('DDMMYYY'))
      $("[name=debtDate]").val(moment(latestCustomSale.debtDate).format('DDMMYYY'))
    else
      $("[name=paidDate]").val('')
      $("[name=debtDate]").val('')


#    if latestSale = Schema.sales.findOne({buyer: staff._id}, {sort: {'version.createdAt': -1}})
#      if latestTransaction = Schema.transactions.findOne({latestSale: latestSale._id}, {sort: {debtDate: -1}})
#        $("[name=paidSaleDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
#      else
#        $("[name=paidSaleDate]").val(moment(latestSale.version.createdAt).format('DDMMYYY'))
#    else
#      $("[name=paidSaleDate]").val('')

#  if Session.get("staffManagementCurrentStaff")
    #staffManagementData
#    Meteor.subscribe('staffManagementData', Session.get("staffManagementCurrentStaff")._id)
#    Meteor.subscribe('availableCustomSaleOf', Session.get("staffManagementCurrentStaff")._id)
#    Meteor.subscribe('availableSaleOf', Session.get("staffManagementCurrentStaff")._id)
#    Meteor.subscribe('availableReturnOf', Session.get("staffManagementCurrentStaff")._id)