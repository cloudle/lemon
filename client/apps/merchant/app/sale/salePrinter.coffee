setTime = -> Session.set('realtime-now', new Date())

lemon.defineWidget Template.salePrinter,
  dayOfWeek: -> moment(Session.get('realtime-now')).format("dddd")
  timeDMY: -> moment(Session.get('realtime-now')).format("DD/MM/YYYY")
  timeHM: -> moment(Session.get('realtime-now')).format("hh:mm")
  timeS: -> moment(Session.get('realtime-now')).format("ss")
  soldPrice: -> @price - (@price * @discountPercent)
  discountVisible: -> @discountPercent > 0
  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: -> Meteor.clearInterval(@timeInterval)

  events:
    "click .print-button": -> window.print()