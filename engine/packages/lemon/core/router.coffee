@lemon.addRoute = (routes, baseRoute = {}) ->
  routes = [routes] unless Array.isArray(routes)
  for route in routes
    routeLayoutTemplate = route.layoutTemplate
    _.extend(route, baseRoute)
    route.layoutTemplate = routeLayoutTemplate if routeLayoutTemplate

    if route.waitOnDependency
      route.waitOn = ->
        results = lemon.dependencies.resolve(route.waitOnDependency)
        item.ready() for item in results
        results

    modulus.routes.push route
  return

@lemon.buildRoutes = (router) ->
  for route in modulus.routes
    template = undefined

    if route.template and route.path
      template = route.template; delete route.template
    else if route.template
      template = route.template; delete route.template
      route.path = "/#{template}"
    else if route.path
      template = route.path.substring(1)

    router.route template, route if template