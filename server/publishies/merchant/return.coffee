Meteor.publish 'returnDetails', (returnId) ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  returns = Schema.returns.findOne({_id: returnId, status: {$ne: 2}})
  Schema.returnDetails.find {return: returns._id}


Schema.returns.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.returnDetails.allow
  insert: -> true
  update: -> true
  remove: -> true