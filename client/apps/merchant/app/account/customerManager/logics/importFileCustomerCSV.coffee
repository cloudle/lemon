checkValidationFileCustomer = (column)->
  data = []
  data.push(item.trim()) for item in column
  console.log data

  customerColumn = {}
  customerColumn.name        = data.indexOf("ten khach hang")
  customerColumn.dateOfBirth = data.indexOf("sinh nhat")
  customerColumn.gender      = data.indexOf("gioi tinh")
  customerColumn.phone       = data.indexOf("so dien thoai")
  customerColumn.address     = data.indexOf("dia chi")

  console.log customerColumn

  (return customerColumn = {} if value is -1) for key, value of customerColumn
  customerColumn

Apps.Merchant.customerManagerInit.push (scope) ->
  scope.importFileCustomerCSV = (data)->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    customerColumn = checkValidationFileCustomer(data[0])
    if _.keys(customerColumn).length > 0
      data = _.without(data, data[0])
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
          styles          : Helpers.RandomColor()

        if Schema.customers.findOne({
            currentMerchant: profile.parentMerchant
            name: item[customerColumn.name]
            phone: item[customerColumn.phone]
          }) then console.log 'Trùng tên khách hàng'
        else Schema.customers.insert option, (error, result) -> if error then console.log error
      MetroSummary.updateMetroSummaryBy(['customer'])

