lemon.log = (params...) ->
  now = new Date()
  params.unshift("#{now.getMinutes()}:#{now.getSeconds()}")
  console.log.apply(console, params)

lemon.sleep = (milliseconds) ->
  start = new Date().getTime()
  for i in [0..1e7]
    break if ((new Date().getTime() - start) > milliseconds)