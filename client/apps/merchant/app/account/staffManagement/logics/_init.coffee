logics.staffManagement = {}
Apps.Merchant.staffManagementInit = []
Apps.Merchant.staffManagementReactive = []

Apps.Merchant.staffManagementReactive.push (scope) ->
  if staffId = Session.get("mySession")?.currentStaffManagementSelection
    Session.set("staffManagementCurrentStaff", Schema.userProfiles.findOne(staffId))

  if staff = Session.get("staffManagementCurrentStaff")
    maxRecords = Session.get("staffManagementDataMaxCurrentRecords")
    countRecords = Schema.customSales.find({buyer: staff._id}).count()
    countRecords += Schema.sales.find({buyer: staff._id}).count() if staff.customSaleModeEnabled is false
    Session.set("showExpandSaleAndCustomSale", (maxRecords is countRecords))