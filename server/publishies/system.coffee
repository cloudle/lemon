Meteor.publish 'fakeWaiter', ->
  self = @
  setTimeout ->
    self.ready()
  , 20000


Meteor.publish 'systems', -> Schema.systems.find {}
Schema.systems.allow
  insert: -> true
  update: -> true
  remove: -> true