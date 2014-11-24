Apps.Merchant.staffManagementReactive.push (scope) ->
  if Session.get("myProfile")
    staffs = Schema.userProfiles.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    groupedStaffs = _.groupBy staffs, (staff) -> staff.fullName.split(' ').pop().substr(0, 1)
    console.log groupedStaffs
    scope.managedStaffList = []
    for key, childs of groupedStaffs
      scope.managedStaffList.push {key: key, childs: childs}