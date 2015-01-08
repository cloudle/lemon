Meteor.methods
  remmoveCollection: (collectionName) ->
    Schema[collectionName].remove({})
  removeUserCollection: -> Meteor.users.remove({})

cleanExceptions = ['systems', 'migrations']

db.clean = ->
  Meteor.call('removeUserCollection'); i = 1
  for name, value of Schema when value instanceof Mongo.Collection and !_(cleanExceptions).contains(name)
    Meteor.call('remmoveCollection', name); i++
  console.log "Database clean complete on #{i} collections"

db.seed = ->
  i = 0
  (script(); i++) for script in modulus.seedScripts
  console.log "Seeding complete, there are #{i} scripts executed!"

db.setup = -> db.clean(); db.seed()