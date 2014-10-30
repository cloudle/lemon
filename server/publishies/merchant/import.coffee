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

Schema.imports.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.importDetails.allow
  insert: -> true
  update: -> true
  remove: -> true
