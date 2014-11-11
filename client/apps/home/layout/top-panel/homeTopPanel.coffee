Session.set('topPanelMinimize', true)
toggleTopPanel = -> Session.set('topPanelMinimize', !Session.get('topPanelMinimize'))

lemon.defineWidget Template.homeTopPanel,
  minimizeClass: -> if Session.get('topPanelMinimize') then 'minimize' else ''
  toggleIcon: -> if Session.get('topPanelMinimize') then 'icon-up-open-3' else 'icon-down-open-3'
  showRegisterToggle: -> Meteor.userId() is null

#  registerValid: ->
#    if Session.get('registerAccountValid') == Session.get('registerSecretValid') == 'valid'
#      'valid'
#    else
#      'invalid'

  created: ->
    Session.setDefault('registerAccountValid', 'invalid')
    Session.setDefault('registerSecretValid', 'invalid')

  events:
    "click .top-panel-toggle": -> toggleTopPanel(); console.log Session.get('topPanelMinimize')

#    "keypress #secretConfirm": (event, template) ->
#      $(template.find("#merchantRegister")).click() if event.which is 13 and Template.homeTopPanel.registerValid is 'valid'
#    "input #secretConfirm": (event, template) ->
#      $secret  = $(template.find("#secret"))
#      $secretConfirm = $(template.find("#secretConfirm"))
#      if $secretConfirm.val().length > 0 or $secret.val().length > 0 or $secretConfirm.val() is $secret.val()
#        Session.set('registerSecretValid', 'valid')
#      else
#        Session.set('registerSecretValid', 'invalid')