Helpers.deferredAction = (action, uniqueName, timeOut = 200) ->
  Meteor.clearTimeout(Apps.currentDefferedTimeout) if Apps.currentDefferedActionName is uniqueName

  Apps.currentDefferedTimeout = Meteor.setTimeout ->
    action()
  , timeOut

  Apps.currentDefferedActionName = uniqueName if uniqueName