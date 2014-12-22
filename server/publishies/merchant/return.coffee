Meteor.publish 'returnDetails', (returnId) ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  returns = Schema.returns.findOne({_id: returnId, status: {$ne: 2}})
  Schema.returnDetails.find {return: returns._id}

Meteor.publishComposite 'returnManagementData', (customerId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      mySession = Schema.userSessions.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile or !mySession

      allMerchants = Schema.merchants.find({$or:[{_id: myProfile.parentMerchant }, {parent: myProfile.parentMerchant}]})
      Schema.sales.find {buyer: customerId, merchant: $in: _.union(_.pluck(allMerchants.fetch(), '_id'))}
    children: [
      find: (sale) -> Schema.imports.find {sale: sale._id}
      children: [
        find: (currentImport, sale) -> Schema.importDetails.find {import: currentImport._id}
      ]
    ]
  }


Meteor.publishComposite 'availableReturnOf', (customerId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      allMerchants = Schema.merchants.find({$or:[{_id: myProfile.parentMerchant }, {parent: myProfile.parentMerchant}]})
      Schema.sales.find {buyer: customerId, merchant: $in: _.union(_.pluck(allMerchants.fetch(), '_id'))}
    children: [
      find: (sale) -> Schema.imports.find {sale: sale._id}
      children: [
        find: (currentImport, sale) -> Schema.importDetails.find {import: currentImport._id}
      ]
    ]
  }


Schema.returns.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.returnDetails.allow
  insert: -> true
  update: -> true
  remove: -> true