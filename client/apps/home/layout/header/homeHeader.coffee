lemon.defineWidget Template.homeHeader,
  languages: -> i18n.languages

  created: -> Session.setDefault('loginValid', 'invalid')
  rendered: -> $(@find("#authAlias")).val($.cookie('lastAuthAlias'))
  events:
    "click .languages li": -> i18n.setLanguage @key
    "click #authButton.valid": (event, template) -> logics.homeHeader.login(event, template)
    "click #logoutButton": -> lemon.logout()
    "click #gotoMerchantButton": -> Router.go('/dashboard')
    "click .logo-text": -> Router.go('/dashboard') if Meteor.userId() isnt null

    "keypress .login-field": (event, template) ->
      $(template.find("#authButton")).click() if event.which is 13 and Session.get('loginValid') is 'valid'

    "input .login-field": (event, template) ->
      $login    = $(template.find("#authAlias"))
      $password = $(template.find("#authSecret"))
      if $login.val().length > 0 and $password.val().length > 0
        Session.set('loginValid', 'valid')
      else
        Session.set('loginValid', 'invalid')