scope = logics.roleManagement

lemon.defineApp Template.roleManagement,
  allowCreate: -> if Session.get('allowCreateNewRole') then '' else 'disabled'
  allowUpdate: -> if Session.get('currentRoleSelection')?.parent then '' else 'disabled'

  roleActiveClass: -> if Session.get('currentRoleSelection')?._id is @_id then "active" else ""
  hasCustomPermission: -> scope.managedCustomRoles.length > 0
  hasBuitInPermission: -> scope.managedBuitInRoles.length > 0
  showFilterSearch: -> Session.get("roleManagementSearchFilter")?.length > 0
  creationMode: -> Session.get("roleManagementCreationMode")
  showChangePermission: ->
    if Session.get('currentRoleSelection')?.parent is Session.get('myProfile')?.parentMerchant then true else false

  created: -> scope.templateContext = @
  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("roleManagementSearchFilter", template.ui.$searchFilter.val())
      , "roleManagementSearchRole"

    "keypress input[name='searchFilter']": (event, template)-> scope.createNewRole(event, template)
    "click .createRoleBtn": (event, template) -> scope.createNewRole(event, template)
    "click .caption.inner": (event, template) -> Session.set("currentRoleSelection", @)
    "click .savePermission": (event, template)-> scope.saveRoleOptions(event, template)
    "click .deleteNewRole": (event, template) -> scope.deleteNewRole(@_id); event.stopPropagation()

#    "input [name='newGroupName']": (event, template) -> scope.checkAllowCreate(template)
#    "click #newGroupButton:not(.disabled)": (event, template)-> scope.createNewRole(event, template)
#    "click #updateButton": (event, template) -> scope.saveRoleOptions(event, template)
