scope = logics.merchantOptions

syncGenderStatus = (switchery, gender) -> switchery.element.click() if switchery.isChecked() isnt gender

lemon.defineHyper Template.merchantAccountOptions,
  profile: -> Session.get("myProfile")
  gender: -> Session.get("merchantAccountOptionsGenderSelection") ? @gender
  showEditCommand: -> Session.get("merchantAccountOptionShowEditCommand")
  showChangePasswordCommand: -> Session.get("merchantAccountOptionChangePasswordCommand")

  rendered: ->
    scope.accountOptionsTemplate = @
    syncGenderStatus(this.switch.gender, Session.get("myProfile")?.gender ? true)
    @datePicker.$dateOfBirth.datepicker('setDate', Session.get('myProfile')?.dateOfBirth)

  events:
    "change [name='gender']": (event, template) ->
      Session.set("merchantAccountOptionsGenderSelection", event.target.checked)
      scope.checkUpdateAccountOption(template)

    "change [name='dateOfBirth']": (event, template) -> scope.checkUpdateAccountOption(template)
    "input .accountProfileOption": (event, template) -> scope.checkUpdateAccountOption(template)
    "keyup .accountProfileOption": (event, template) -> scope.updateAccountOption(template) if event.which is 13
    "click .syncAccountProfileEdit": (event, template) -> scope.updateAccountOption(template)


    "input .accountChangePassword": (event, template) -> scope.checkAccountChangePassword(template)
    "keyup .accountChangePassword": (event, template) -> scope.updateAccountOptionChangePassword(template) if event.which is 13
    "click .changeAccountProfilePassword": (event, template) -> scope.updateAccountOptionChangePassword(template)


