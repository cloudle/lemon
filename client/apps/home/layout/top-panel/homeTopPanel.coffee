Session.set('topPanelMinimize', true)
toggleTopPanel = -> Session.set('topPanelMinimize', !Session.get('topPanelMinimize'))

lemon.defineWidget Template.homeTopPanel,
  minimizeClass: -> if Session.get('topPanelMinimize') then 'minimize' else ''
  toggleIcon: -> if Session.get('topPanelMinimize') then 'icon-up-open-3' else 'icon-down-open-3'

  created: ->
    Session.setDefault('registerAccountValid', 'invalid')
    Session.setDefault('registerSecretValid', 'invalid')

  events:
    "click .top-panel-toggle": -> toggleTopPanel(); console.log Session.get('topPanelMinimize')