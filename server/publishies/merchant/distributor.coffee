Meteor.publish 'availableDistributors', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.distributors.find({parentMerchant: myProfile.parentMerchant})


Meteor.publishComposite 'distributorManagementData', (distributorId, currentRecords = 0)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.distributors.find {_id: distributorId, parentMerchant: myProfile.parentMerchant}
    children: [
      find: (distributor) -> Schema.imports.find {distributor: distributor._id, finish: true, submitted: true}
      children: [
        find: (currentImport, distributor) -> Schema.importDetails.find {import: currentImport._id}
        children: [
          find: (importDetail, distributor) -> Schema.products.find {_id: importDetail.product}
        ]
      ]
    ,
      find: (distributor) -> Schema.customImports.find {seller: distributor._id}
      children: [
        find: (customImport, distributor) -> Schema.customImportDetails.find {customImport: customImport._id}
      ]
    ,
      find: (distributor) -> Schema.transactions.find {owner: distributor._id}
    ]
  }

Schema.distributors.allow
  insert: (userId, distributor)->
    findDistributor = Schema.providers.findOne({name: distributor.name, parentMerchant: distributor.parentMerchant})
    if findDistributor then false else true

  update: (userId, distributor)-> true
  remove: (userId, distributor)->
    if distributor.allowDelete
      if Schema.imports.findOne({distributor: distributor._id}) then false else true