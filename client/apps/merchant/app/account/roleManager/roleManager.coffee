lemon.defineApp Template.roleManager,
  allowCreate: -> if Session.get('allowCreateNewRole') then '' else 'disabled'
  created: ->
    logics.roleManager.rolesTemplateContext = @

  events:
    "input [name='newGroupName']": (event, template) -> logics.roleManager.checkAllowCreate(template)
    "click #newGroupButton:not(.disabled)": (event, template)-> logics.roleManager.createNewRole(event, template)
    "click #updateButton": (event, template) -> logics.roleManager.saveRoleOptions(event, template)