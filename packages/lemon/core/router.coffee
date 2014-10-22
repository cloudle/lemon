@lemon.addRoute = (routes) ->
  if Array.isArray(routes)
    modulus.routes.push route for route in routes
  else
    modulus.routes.push routes

@lemon.buildRoutes = (context) ->
  for route in modulus.routes
    template = undefined

    if route.template and route.path
      template = route.template; delete route.template
    else if route.template
      template = route.template; delete route.template
      route.path = "/#{template}"
    else if route.path
      template = route.path.substring(1)

    context.route template, route if template
