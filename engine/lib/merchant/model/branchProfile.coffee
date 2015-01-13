Schema.branchProfiles = new Mongo.Collection('branchProfiles')
#
#@MerchantProfile =
#  set: (key, value, getRoot = true, applyOnBranch = false) ->
#    return false if !Session.get('myProfile')?.currentMerchant
#    options = {}; options[key] = value
#    if getRoot
#      query = {merchant: Session.get('myProfile').parentMerchant}
#    else
#      query = {merchant: Session.get('myProfile').currentMerchant}
#
#    found = Schema.merchantProfiles.findOne(query)
#    if found
#      Schema.merchantProfiles.update(found._id, {$set: options})
#    else
#      options.merchant = query.merchant
#      profile = Schema.merchantProfiles.insert(options)
#  get: (key, getRoot = true) ->
#    Schema.merchantProfiles.findOne({merchant: Meteor.userId()})?[key]