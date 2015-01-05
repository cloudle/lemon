lemon.defineWidget Template.homeHeader,
  languages: -> i18n.languages

  created: -> Session.setDefault('loginValid', 'invalid')
  rendered: -> $(@find("#authAlias")).val($.cookie('lastAuthAlias'))
  events:
    "click .languages span": -> i18n.setLanguage @key
    "click .logo-text": -> Router.go('/merchant') if Meteor.userId() isnt null