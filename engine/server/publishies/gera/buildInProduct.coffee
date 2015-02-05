Meteor.publishComposite 'availableBuildInProducts', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !profile
      Schema.buildInProducts.find()
    children: [
      find: (buildInProduct) -> Schema.buildInProductUnits.find {buildInProduct: buildInProduct._id}
    ]
  }

Meteor.publishComposite 'currentBuildInProductData', ->
  self = @
  return {
    find: ->
      session = Schema.userSessions.findOne({user: self.userId})
      return EmptyQueryResult if !session
      Schema.buildInProducts.find({_id: session.currentGeraProductManagementSelection})
    children: [
      find: (buildInProduct) ->
        if buildInProduct.merchantRegister and buildInProduct.merchantRegister?.length > 0
          Schema.merchants.find {_id: {$in:buildInProduct.merchantRegister} }
        else EmptyQueryResult
    ]
  }



Meteor.publishComposite 'availableGeraProductGroups', ->
  self = @
  return {
    find: ->
      profile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !profile
      Schema.productGroups.find({buildIn: true})
  }

Schema.buildInProductUnits.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.buildInProducts.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.productGroups.allow
  insert: -> true
  update: -> true
  remove: -> true
