Schema.userSessions = new Mongo.Collection('userSessions')

@UserSession =
  set: (key, value) ->
    return false if !Meteor.userId()
    options = {}; options[key] = value
    found = Schema.userSessions.findOne({user: Meteor.userId()})
    if found
      Schema.userSessions.update(found._id, {$set: options})
    else
      options.user = Meteor.userId()
      userSession = Schema.userSessions.insert(options)
  get: (key) -> Schema.userSessions.findOne({user: Meteor.userId()})?[key]
