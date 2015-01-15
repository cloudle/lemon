scope = logics.merchantOptions

syncGenderStatus = (switchery, gender) -> switchery.element.click() if switchery.isChecked() isnt gender

lemon.defineHyper Template.merchantAccountOptions,
  gender: ->
    if scope.accountOptionsTemplate
      switchery = scope.accountOptionsTemplate.switch.gender
      syncGenderStatus(switchery, @gender)
    @gender
  profile: -> Session.get("myProfile")
  rendered: ->
    scope.accountOptionsTemplate = @
    syncGenderStatus(this.switch.gender, Session.get("myProfile")?.gender ? true)
    @datePicker.$dateOfBirth.datepicker('setDate', Session.get('myProfile')?.dateOfBirth)

  events:
    "change [name='gender']": (event, template) ->
      Session.set("createStaffGenderSelection", event.target.checked)
