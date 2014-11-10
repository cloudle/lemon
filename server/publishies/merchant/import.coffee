Meteor.publish 'myImportHistory', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  myImports = Schema.imports.find({
    creator  : myProfile.user,
    merchant : myProfile.currentMerchant,
    warehouse: myProfile.currentWarehouse})

#  myImportDetails = Schema.importDetails.find({import: {$in:_.pluck(myImports.fetch(), '_id')}})
#  [myImports,   myImportDetails]


Meteor.publish 'importDetails', (importId) ->
  currentOrder = Schema.imports.findOne(importId)
  return [] if !@userId or currentOrder?.creator isnt @userId
  Schema.importDetails.find {import: importId}


#----------ImportReview--------------------------------------------------------------
Meteor.publishComposite 'importHistoryInWarehouse', ->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.imports.find {submitted: true, warehouse: myProfile.currentWarehouse}
    children: [
      find: (imports) -> Schema.userProfiles.find {user: imports.creator}
    ]
  }

Meteor.publishComposite 'importDetailInWarehouse', (importId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.importDetails.find {import: importId, warehouse: myProfile.currentWarehouse}
    children: [
      find: (importDetail) -> Schema.products.find {_id: importDetail.product}
    ]
  }
#---------------------------------------------------------------------------


Schema.imports.allow
  insert: (userId, imports) -> true
  update: (userId, imports) -> true
  remove: (userId, imports) -> true

Schema.importDetails.allow
  insert: (userId, importDetail) -> true
  update: (userId, importDetail) -> true
  remove: (userId, importDetail) -> true
