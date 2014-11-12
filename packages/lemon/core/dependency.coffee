lemon.dependencies = {}

lemon.dependencies.add = (name, deps) ->
  lemon.dependencies[name] = deps

lemon.dependencies.list = (dep = undefined ) ->
  if dep and lemon.dependencies[dep]
    console.log recursiveResolve(lemon.dependencies[dep])
  else
    console.log name, value for name, value of lemon.dependencies when Array.isArray(value)
  return

lemon.dependencies.resolve = (name) ->
  return if !lemon.dependencies[name]
  dependencies = recursiveResolve(lemon.dependencies[name])

  subscriptions = []
  for dep in dependencies
    if typeof(dep) is 'string'
      subscriptions.push Meteor.subscribe.call(Meteor, dep)
    else if Array.isArray(dep)
      subscriptions.push Meteor.subscribe.apply(Meteor, dep)

  return subscriptions

#Helpers -------------------------------------------------------------->
recursiveResolve = (nextDep, currentDeps = []) ->
  for dep in nextDep
    continue if _.findWhere(currentDeps, dep)
    if lemon.dependencies[dep]
      recursiveResolve(lemon.dependencies[dep], currentDeps)
    else
      currentDeps.push(dep)

  currentDeps

#lemon.dependencies.add('essentials', ['myMetaData', 'messages'])
#lemon.dependencies.add('chat', ['essentials', 'users', 'messages'])
#lemon.dependencies.add('sales', ['chat', 'users', 'customers', 'sellers', 'products', 'bills', 'systems'])
#lemon.dependencies.add('warehouse', [['product', 1], 'productDetails', 'users'])
#
#lemon.dependencies.add('dep1', ['warehouse', 'chat', 'sales'])
#lemon.dependencies.add('dep2', ['chat', 'sales', 'history'])
#lemon.dependencies.add('dep3', ['chat', 'warehouse'])
#lemon.dependencies.add('dep4', ['chat'])
#lemon.dependencies.add('dep5', ['dep1', 'dep2', 'new'])
#lemon.dependencies.add('dep6', ['dep2', 'new'])
#lemon.dependencies.add('dep7', ['dep3', 'sales', 'dep1', 'chat'])
