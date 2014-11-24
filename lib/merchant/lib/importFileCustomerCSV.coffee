checkValidationFileCustomer = (column)->
  data = []
  data.push(item.trim()) for item in column
  console.log data

  customerColumn = {}
  customerColumn.name        = data.indexOf("ten khach hang")
  customerColumn.dateOfBirth = data.indexOf("sinh nhat")
  customerColumn.gender      = data.indexOf("gioi tinh")
  customerColumn.pronoun     = data.indexOf("xung ho")
  customerColumn.phone       = data.indexOf("so dien thoai")
  customerColumn.address     = data.indexOf("dia chi")
  customerColumn.areas       = data.indexOf("khu vuc")
  customerColumn.description = data.indexOf("ghi chu")

  console.log customerColumn

  (return customerColumn = {} if value is -1) for key, value of customerColumn
  customerColumn

checkAndAddNewCustomerArea = (customerColumn, data, profile) ->
  areas = []
  customerAreas = []
  for customer in data
    (areas.push(item.trim()) if item) for item in customer[customerColumn.areas].split(",")
  areas = _.union(areas)

  if areas.length > 0
    for item in areas
      if customerArea = Schema.customerAreas.findOne({
        parentMerchant: profile.parentMerchant
        name: item
      })
      else
        customerArea =
          parentMerchant  : profile.parentMerchant
          creator         : profile.user
          name            : item
        customerArea._id = Schema.customerAreas.insert customerArea, (error, result) -> if error then console.log error
      customerAreas.push customerArea
  customerAreas


checkPronoun = (gender, pronoun)-> if pronoun.length > 0 then pronoun else (if gender then 'Anh' else 'Chị')
findCustomerAreas = (customerAreas, areaNames)->
  areas = []
  if areaNames.length > 0
    for areaName in areaNames
      areas.push(_.findWhere(customerAreas, {name: areaName.trim()})._id)
  areas

addNewCustomers = (customerColumn, data, profile, customerAreas) ->
  for item in data
    option =
      parentMerchant  : profile.parentMerchant
      currentMerchant : profile.currentMerchant
      creator         : profile.user
      name            : item[customerColumn.name]
      gender          : if item[customerColumn.gender] is 'Nam' or item[customerColumn.gender] is 'nam' then true else false
      phone           : item[customerColumn.phone]
      address         : item[customerColumn.address]
      dateOfBirth     : moment(item[customerColumn.dateOfBirth], "DD/MM/YYYY")._d
      description     : item[customerColumn.description]
      styles          : Helpers.RandomColor()
    option.pronoun = checkPronoun(option.gender, item[customerColumn.pronoun])
    option.areas   = findCustomerAreas(customerAreas, item[customerColumn.areas].split(",")) if item[customerColumn.areas]

    if Schema.customers.findOne({
      currentMerchant: profile.parentMerchant
      name       : item[customerColumn.name]
      description: item[customerColumn.description]
    }) then console.log 'Trùng tên khách hàng'
    else Schema.customers.insert option, (error, result) -> if error then console.log error
  MetroSummary.updateMetroSummaryBy(['customer'])

Apps.Merchant.importFileCustomerCSV = (data)->
  profile = Schema.userProfiles.findOne({user: Meteor.userId()})
  customerColumn = checkValidationFileCustomer(data[0])
  if _.keys(customerColumn).length > 0
    data = _.without(data, data[0])
    customerAreas = checkAndAddNewCustomerArea(customerColumn, data, profile)
    addNewCustomers(customerColumn, data, profile, customerAreas)

