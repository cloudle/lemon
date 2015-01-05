Apps.Merchant.staffManagementReactive.push (scope) ->
  if Session.get("myProfile")
    staffs = Schema.userProfiles.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch()
    scope.managedStaffList = []
    if Session.get("staffManagementSearchFilter")?.length > 0
      scope.managedStaffList = _.filter staffs, (item) ->
        unsignedTerm = Helpers.RemoveVnSigns Session.get("staffManagementSearchFilter")
        unsignedName = Helpers.RemoveVnSigns item.fullName
        unsignedName.indexOf(unsignedTerm) > -1
    else
      groupedStaffs = _.groupBy staffs, (staff) -> staff.fullName?.split(' ').pop().substr(0, 1).toLowerCase()
      scope.managedStaffList.push {key: key, childs: childs} for key, childs of groupedStaffs
      scope.managedStaffList = _.sortBy(scope.managedStaffList, (num)-> num.key)

    if Session.get("staffManagementSearchFilter")?.trim().length > 1
      if scope.managedStaffList.length > 0
        staffNameLists = _.pluck(scope.managedStaffList, 'fullName')
        Session.set("staffManagementCreationMode", !_.contains(staffNameLists, Session.get("staffManagementSearchFilter").trim()))
      else
        Session.set("staffManagementCreationMode", true)

    else
      Session.set("staffManagementCreationMode", false)