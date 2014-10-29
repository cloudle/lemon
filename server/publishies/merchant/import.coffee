Meteor.publish 'myImportHistoryAndDetail', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  myImports = Schema.imports.find({
    creator  : myProfile.user,
    merchant : myProfile.currentMerchant,
    warehouse: myProfile.currentWarehouse})

  myImportDetails = Schema.importDetails.find({import: {$in:_.pluck(myImports.fetch(), '_id')}})

  [myImports,   myImportDetails]

Schema.imports.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.importDetails.allow
  insert: -> true
  update: -> true
  remove: -> true
