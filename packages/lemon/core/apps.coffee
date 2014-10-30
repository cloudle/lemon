Apps.setup = (scope, initializers) ->
  return if !initializers or !Array.isArray(initializers)
  init(scope) for init in initializers when typeof(init) is 'function'