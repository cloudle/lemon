scope = logics.staffManager

lemon.defineApp Template.staffManager,
  allowCreate: -> if Session.get('allowCreateStaffAccount') then '' else 'disabled'

#  rendered: ->
#    Sky.global.staffManagerTemplateInstance = @
#    @ui.$dateOfBirth.datepicker
#      language: "vi"
#
#    @ui.$startWorkingDate.datepicker
#      language: "vi"
#      todayHighlight: true
#
  events:
    "input input": (event, template) -> scope.checkAllowCreate(template)
    "change [name='genderMode']": (event, template) ->
      Session.set("createStaffGenderSelection", event.target.checked)

    "click #createStaffAccount": (event, template) -> scope.createStaffAccount(template)

    "blur #email": (event, template)->
      $email = $(template.find("#email"))
      if $email.val().length > 0
        unless Helpers.isEmail($email.val()) then $email.notify('Tài khoản phải là email')