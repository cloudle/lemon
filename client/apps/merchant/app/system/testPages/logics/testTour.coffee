step1 =
  element: "#step1 h1"
  title: "Title of my step"
  content: "Content of my step"

step2 =
  element: "#step2 h1"
  title: "Title of my step"
  content: "Content of my step"

Apps.Merchant.testInit.push (scope) ->
  console.log 'initializing tour', scope
  scope.tour = new Tour
#    container: "body"
    backdrop: true

  scope.tour.addStep(step1)
  scope.tour.addStep(step2)