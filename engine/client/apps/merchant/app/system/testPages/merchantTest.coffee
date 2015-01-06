scope = logics.merchantTest
logTxt = -> console.log 'txt, i am deffered excuted!'


lemon.defineApp Template.merchantTest,
  rendered: ->
    console.log scope.tour
#    scope.tour.init()
#    scope.tour.restart()
  events:
    "click .defferedBtn": ->
      Helpers.deferredAction ->
        console.log 'btn, i am deffered excuted!'
    "input .defferedTxt": ->
      Helpers.deferredAction ->
        logTxt()
      , "testDefferedTxt"
