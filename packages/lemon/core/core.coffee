lemon.log = (params...) ->
  now = new Date()
  params.unshift("#{now.getMinutes()}:#{now.getSeconds()}")
  console.log.apply(console, params)

lemon.ExcuteLogics = -> UserSession.set("ExcuteLogics", Meteor.uuid())

lemon.sleep = (milliseconds) ->
  start = new Date().getTime()
  for i in [0..1e7]
    break if ((new Date().getTime() - start) > milliseconds)

goldenRatio = 1.618
lemon.designRatio = {}
lemon.designRatio.baseSize = (fullSize) -> fullSize / goldenRatio
lemon.designRatio.addOnSize = (baseSize) -> baseSize / goldenRatio
lemon.designRatio.fullSize = (baseSize) -> baseSize * goldenRatio
lemon.designRatio.split = (fullSize) ->
  baseSize = lemon.designRatio.baseSize(fullSize)
  addOnSize = lemon.designRatio.addOnSize(baseSize)
  return { base: baseSize, addOn: addOnSize}
