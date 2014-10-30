Apps.setupHistories = []
Apps.setup = (scope, initializers, appName) ->
  return if !initializers or !Array.isArray(initializers) or _.contains(Apps.setupHistories, appName)
  init(scope) for init in initializers when typeof(init) is 'function'
  Apps.setupHistories.push appName if appName