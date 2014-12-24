Meteor.publish 'availableDistributors', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.distributors.find({parentMerchant: myProfile.parentMerchant})


Meteor.publishComposite 'distributorManagementData', (distributorId, currentRecords = 0, limitRecords = 5)->
  self = @
  importCount = Schema.imports.find({distributor: distributorId, finish: true, submitted: true}).count()
  customImportCount = Schema.customImports.find({seller: distributorId}).count()

  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.distributors.find {_id: distributorId, parentMerchant: myProfile.parentMerchant}
    children: [
      find: (distributor) ->
        if distributor.customSaleModeEnabled
          if customImportCount > currentRecords
            skipCustomImportRecords  = currentRecords
            limitCustomImportRecords = limitRecords
          else
            skipCustomImportRecords  = customImportCount
            limitCustomImportRecords = 0
          Schema.customImports.find {seller: distributor._id}, {sort: {debtDate: -1}, skip: skipCustomImportRecords, limit: limitCustomImportRecords}
        else
          if importCount < currentRecords + limitRecords
            if importCount + limitRecords > currentRecords
              skipCustomImportRecords  = 0
              limitCustomImportRecords = limitRecords + currentRecords - importCount
            else
              skipCustomImportRecords  = currentRecords - importCount
              limitCustomImportRecords = limitRecords
            Schema.customImports.find {seller: distributor._id}, {sort: {debtDate: -1}, skip: skipCustomImportRecords, limit: limitCustomImportRecords}
          else
            EmptyQueryResult
      children: [
        find: (customImport, distributor) -> Schema.customImportDetails.find {customImport: customImport._id}
      ]
    ,
      find: (distributor) ->
        if distributor.customImportModeEnabled
          Schema.imports.find {distributor: distributor._id, finish: true, submitted: true}
        else
          if importCount > currentRecords
            skipImportRecords  = currentRecords
            limitImportRecords = limitRecords
            Schema.imports.find {distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': -1}, skip: skipImportRecords, limit: limitImportRecords}
          else
            EmptyQueryResult
      children: [
        find: (currentImport, distributor) -> Schema.productDetails.find {import: currentImport._id}
        children: [
          find: (productDetail, distributor) -> Schema.products.find {_id: productDetail.product}
          children: [
            find: (product, distributor) -> Schema.productUnits.find {product: product._id}
          ]
        ]
      ]
    ,
      find: (distributor) -> Schema.transactions.find {owner: distributor._id}
    ,
      find: (distributor) -> Schema.returns.find {distributor: distributor._id, status: 2}
      children: [
        find: (currentReturn, distributor) -> Schema.returnDetails.find {return: currentReturn._id}
      ]
    ]
  }

Schema.distributors.allow
  insert: (userId, distributor)->
    findDistributor = Schema.providers.findOne({name: distributor.name, parentMerchant: distributor.parentMerchant})
    if findDistributor then false else true

  update: (userId, distributor)-> true
  remove: (userId, distributor)->
    if distributor.allowDelete
      importFound = Schema.imports.findOne({distributor: distributor._id})
      customImportFound = Schema.customImports.findOne({seller: distributor._id})
      if importFound is undefined and customImportFound is undefined then true else false