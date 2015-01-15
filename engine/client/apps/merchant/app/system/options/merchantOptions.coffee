lemon.defineAppContainer Template.merchantOptions,
  currentSectionDynamic: -> Session.get("merchantOptionsCurrentDynamics")
  optionActiveClass: -> if @template is Session.get("merchantOptionsCurrentDynamics")?.template then 'active' else ''
  testHelper: ->
    console.log 'taken helper'
    return 'from helper'

  rendered: -> console.log 'rendered'
  events:
    "click .caption.inner": -> Session.set("merchantOptionsCurrentDynamics", @)