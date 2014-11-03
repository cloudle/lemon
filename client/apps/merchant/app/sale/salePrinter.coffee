setTime = -> Session.set('realtime-now', new Date())

lemon.defineWidget Template.salePrinter,
  dayOfWeek: -> moment(Session.get('realtime-now')).format("dddd")
  fullDay: -> moment(Session.get('realtime-now')).format("dd/MM/YYYY")
  timeHook: -> moment(Session.get('realtime-now')).format("hh:mm ss")
  soldPrice: -> @price - (@price * @discountPercent)

  created: -> @timeInterval = setInterval(setTime, 1000)
  destroyed: -> clearInterval(@timeInterval)