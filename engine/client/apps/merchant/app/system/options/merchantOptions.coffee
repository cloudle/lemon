lemon.defineAppContainer Template.merchantOptions,
  currentSectionDynamic: -> Session.get("merchantOptionsCurrentDynamics")
  optionActiveClass: -> if @template is Session.get("merchantOptionsCurrentDynamics")?.template then 'active' else ''
  events:
    "click .caption.inner": -> Session.set("merchantOptionsCurrentDynamics", @)