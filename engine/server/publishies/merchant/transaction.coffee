Meteor.publish 'availableReceivable', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.transactions.find({merchant: myProfile.currentMerchant, warehouse: myProfile.currentWarehouse})

Meteor.publish 'availablePayable', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  allMerchants = Schema.merchants.find({$or:[{_id: myProfile.parentMerchant }, {parent: myProfile.parentMerchant}]})

  Schema.transactions.find({
    merchant: $in: _.union(_.pluck(allMerchants.fetch(), '_id'))
    status  : 'tracking'
    group   : {$in:['import']} })

Meteor.publishComposite 'oldReceivable',(customerId) ->
  self = @
  return {
  find: ->
    myProfile = Schema.userProfiles.findOne({user: self.userId})
    return EmptyQueryResult if !myProfile
    allMerchants = Schema.merchants.find({$or:[{_id: myProfile.parentMerchant }, {parent: myProfile.parentMerchant}]})

    Schema.transactions.find({
      merchant  : $in: _.union(_.pluck(allMerchants.fetch(), '_id'))
      owner     : customerId
      status    : 'tracking'
      group     : {$in:['customer', 'sale']}
      receivable: true
    })

#  children: [
#    find: (transaction) -> Schema.customers.find {_id: transaction.owner}
#    children: [
#      find: (customer, transaction) -> AvatarImages.find {_id: customer.avatar}
#    ]
#  ]
  }


Meteor.publish 'oldPayable',(distributorId) ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  allMerchants = Schema.merchants.find({$or:[{_id: myProfile.parentMerchant }, {parent: myProfile.parentMerchant}]})

  Schema.transactions.find({
    merchant  : $in: _.union(_.pluck(allMerchants.fetch(), '_id'))
    owner     : distributorId
    status    : 'tracking'
    group     : {$in:['distributor', 'import']}
    receivable: false
  })



Meteor.publishComposite 'receivableAndRelates', -> #No phai thu
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.transactions.find({merchant: myProfile.currentMerchant, warehouse: myProfile.currentWarehouse})
#      Schema.transactions.find({merchant: myProfile.currentMerchant, warehouse: myProfile.currentWarehouse, group: 'sale'})
    children: [
      find: (transaction) -> Schema.customers.find {_id: transaction.owner}
      children: [
        find: (customer, transaction) -> AvatarImages.find {_id: customer.avatar}
      ]
    ]
  }

Meteor.publishComposite 'transactionDetails', (transactionId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.transactionDetails.find({transaction: transactionId, merchant: myProfile.currentMerchant})
    children: [
      find: (transactionDetail) -> Schema.userProfiles.find {user: transactionDetail.creator}
#      children: [
#        find: (customer, transaction) -> AvatarImages.find {_id: customer.avatar}
#      ]
    ]
  }




#Meteor.publishComposite 'myMerchantContacts',
#  find: ->
#    currentProfile = Schema.userProfiles.findOne({user: @userId})
#    return [] if !currentProfile
#    Schema.userProfiles.find { currentMerchant: currentProfile.currentMerchant }
#  children: [
#    find: (profile) -> Meteor.users.find {_id: profile.user}
#  ,
#    find: (profile) -> AvatarImages.find {_id: profile.avatar}
#  ]

Schema.transactions.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.transactionDetails.allow
  insert: (userId, transactionDetail)->
#    profile = Schema.userProfiles.findOne({user: userId})
#    metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant})
#    Schema.metroSummaries.update metroSummary._id, $inc: {
#      saleDepositCash       : transactionDetail.depositCash
#      saleDebitCash         : -transactionDetail.depositCash }

    true

  update: (userId, transactionDetail)-> true
  remove: (userId, transactionDetail)-> true