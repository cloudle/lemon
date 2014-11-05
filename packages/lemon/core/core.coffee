lemon.GlobalSubscriberCache = new SubsManager
  cacheLimit: 100
  expireIn: 60

lemon.log = (params...) ->
  now = new Date()
  params.unshift("#{now.getMinutes()}:#{now.getSeconds()}")
  console.log.apply(console, params)

lemon.ExcuteLogics = -> UserSession.set("ExcuteLogics", Meteor.uuid())

lemon.sleep = (milliseconds) ->
  start = new Date().getTime()
  for i in [0..1e7]
    break if ((new Date().getTime() - start) > milliseconds)