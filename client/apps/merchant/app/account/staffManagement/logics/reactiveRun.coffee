Apps.Merchant.staffManagementReactive.push (scope) ->
  if Session.get("myProfile")
    staffs = Schema.userProfiles.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    scope.managedStaffList = []
    if Session.get("customerManagementSearchFilter").length > 0
    else
      groupedStaffs = _.groupBy staffs, (staff) -> staff.fullName.split(' ').pop().substr(0, 1) if staff.fullName
      console.log groupedStaffs
      scope.managedStaffList.push {key: key, childs: childs} for key, childs of groupedStaffs
      scope.managedCustomerList = _.sortBy(scope.managedCustomerList, (num)-> num.key)
