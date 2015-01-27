Meteor.publish 'returnDetails', (returnId) ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  returns = Schema.returns.findOne({_id: returnId, status: {$ne: 2}})
  Schema.returnDetails.find {return: returns._id}

Meteor.publishComposite 'allCustomerReturn', ->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.returns.find {creator: myProfile.user, status: 0, returnMethods: 0}
    children: [
      find: (currentReturn) -> Schema.returnDetails.find {return: currentReturn._id}
    ]
  }

Meteor.publishComposite 'allDistributorReturn', ->
  self = @
  return {
  find: ->
    myProfile = Schema.userProfiles.findOne({user: self.userId})
    return EmptyQueryResult if !myProfile
    Schema.returns.find {creator: myProfile.user, status: 0, returnMethods: 1}
  children: [
    find: (currentReturn) -> Schema.returnDetails.find {return: currentReturn._id}
  ]
  }

Meteor.publishComposite 'customerReturnData', (returnId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      if !returnId
        returnId = Schema.userSessions.findOne({user: myProfile.user})?.currentCustomerReturn
      Schema.returns.find {_id: returnId, creator: myProfile.user, status: 0}
    children: [
      find: (currentReturn) -> Schema.returnDetails.find {return: currentReturn._id}
    ,
      find: (currentReturn) -> Schema.customers.find {_id: currentReturn.customer}
    ,
      find: (currentReturn) -> Schema.sales.find {buyer: currentReturn.customer}
      children: [
        find: (sale ,currentReturn) -> Schema.saleDetails.find {sale: sale._id}
        children: [
          find: (productDetail, currentReturn) -> Schema.products.find {_id: productDetail.product}
          children: [
            find: (product, currentReturn) -> Schema.productUnits.find {product: product._id}
            children: [
              find: (productUnit, currentReturn) -> Schema.branchProductUnits.find {productUnit: productUnit._id}
            ]
          ,
            find: (product, currentReturn) -> if product.buildInProduct then Schema.buildInProducts.find {_id: product.buildInProduct} else EmptyQueryResult
            children: [
              find: (buildInProduct, currentReturn) -> Schema.buildInProductUnits.find {buildInProduct: buildInProduct._id}
            ]
          ]
        ]
      ]
    ]
  }

Meteor.publishComposite 'distributorReturnData', (returnId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      if !returnId
        returnId = Schema.userSessions.findOne({user: myProfile.user})?.currentDistributorReturn
      Schema.returns.find {_id: returnId, creator: myProfile.user, status: 0}
    children: [
      find: (currentReturn) -> Schema.returnDetails.find {return: currentReturn._id}
    ,
      find: (currentReturn) -> Schema.distributors.find {_id: currentReturn.distributor}
      children: [
        find: (distributor, currentReturn) -> Schema.productDetails.find {distributor: distributor._id}
        children: [
          find: (productDetail, currentReturn) -> Schema.products.find {_id: productDetail.product}
          children: [
            find: (product, currentReturn) -> Schema.productUnits.find {product: product._id}
            children: [
              find: (productUnit, currentReturn) -> Schema.branchProductUnits.find {productUnit: productUnit._id}
            ]
          ,
            find: (product, currentReturn) -> if product.buildInProduct then Schema.buildInProducts.find {_id: product.buildInProduct} else EmptyQueryResult
            children: [
              find: (buildInProduct, currentReturn) -> Schema.buildInProductUnits.find {buildInProduct: buildInProduct._id}
            ]
          ]
        ]
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