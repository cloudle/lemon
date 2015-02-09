Apps.Merchant.roleManangementReactive.push (scope) ->
  if Session.get("myProfile")
    scope.managedBuitInRoles = []
    scope.managedCustomRoles = []

    if Session.get("roleManagementSearchFilter")?.length > 0
      unsignedSearch = Helpers.RemoveVnSigns Session.get("roleManagementSearchFilter")

      scope.buitInRoles?.forEach(
        (role) ->
          unsignedName = Helpers.RemoveVnSigns role.name
          scope.managedBuitInRoles.push role if unsignedName.indexOf(unsignedSearch) > -1
      )

      scope.customRoles?.forEach(
        (role) ->
          unsignedName = Helpers.RemoveVnSigns role.name
          scope.managedCustomRoles.push role if unsignedName.indexOf(unsignedSearch) > -1
      )
    else
      scope.managedBuitInRoles = scope.buitInRoles?.fetch()
      scope.managedCustomRoles = scope.customRoles?.fetch()

    if Session.get("roleManagementSearchFilter")?.trim().length > 1
      if (scope.managedBuitInRoles.length + scope.managedCustomRoles.length) > 0
        customerNameLists = _.pluck(scope.managedBuitInRoles, 'name')
        customerNameLists = customerNameLists.concat(_.pluck(scope.managedCustomRoles, 'name'))
        Session.set("roleManagementCreationMode", !_.contains(customerNameLists, Session.get("roleManagementSearchFilter").trim()))
      else
        Session.set("roleManagementCreationMode", true)
    else
      Session.set("roleManagementCreationMode", false)