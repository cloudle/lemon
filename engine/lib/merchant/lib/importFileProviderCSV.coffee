checkValidationFileProvider = (column)->
  data = []
  data.push(item.trim()) for item in column

  providerColumn = {}
  providerColumn.name    = data.indexOf("ten nha cung cap")
  providerColumn.address = data.indexOf("dia chi")
  providerColumn.phone   = data.indexOf("so dien thoai")

  (return providerColumn = {} if value is -1) for key, value of providerColumn
  console.log data
  console.log providerColumn
  providerColumn

Apps.Merchant.importFileProviderCSV = (data)->
  profile = Schema.userProfiles.findOne({user: Meteor.userId()})
  providerColumn = checkValidationFileProvider(data[0])
  if _.keys(providerColumn).length > 0
    data = _.without(data, data[0])
    for item in data
      if item[providerColumn.name]
        provider = Schema.providers.findOne({parentMerchant: profile.parentMerchant, name: item[providerColumn.name]})
        if provider then provider._id else Provider.createNew(item[providerColumn.name], item[providerColumn.phone], item[providerColumn.address])