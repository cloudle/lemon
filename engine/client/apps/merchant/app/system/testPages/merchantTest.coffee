scope = logics.merchantTest

lemon.defineApp Template.merchantTest,
  rendered: ->
    console.log scope.tour
    scope.tour.init()
    scope.tour.restart()