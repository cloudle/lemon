#lemon.defineWidget Template.merchantPrintingHeader,
#  dayOfWeek: -> moment(Session.get('realtime-now')).format("dddd")
#  timeDMY: -> moment(Session.get('realtime-now')).format("DD/MM/YYYY")
#  timeHM: -> moment(Session.get('realtime-now')).format("hh:mm")
#  timeS: -> moment(Session.get('realtime-now')).format("ss")