scope = logics.roleManagement

lemon.defineApp Template.roleManagement,
  roleActiveClass: -> if Session.get('currentRoleSelection')?._id is @_id then "active" else ""
  hasCustomPermission: -> scope.customRoles.count() > 0
  allowCreate: -> if Session.get('allowCreateNewRole') then '' else 'disabled'
  allowUpdate: -> if Session.get('currentRoleSelection')?.parent then '' else 'disabled'
  created: -> scope.templateContext = @

  events:
    "click .caption.inner": -> Session.set("currentRoleSelection", @)
#    "input [name='newGroupName']": (event, template) -> scope.checkAllowCreate(template)
#    "click #newGroupButton:not(.disabled)": (event, template)-> scope.createNewRole(event, template)
#    "click #updateButton": (event, template) -> scope.saveRoleOptions(event, template)