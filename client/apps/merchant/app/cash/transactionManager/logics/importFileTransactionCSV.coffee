checkValidationFileTransaction = (column)->
  data = []
  data.push(item.trim()) for item in column
  console.log data

  transactionColumn = {}
  transactionColumn.name        = data.indexOf("ten khach hang")
  transactionColumn.gender      = data.indexOf("gioi tinh")
  transactionColumn.phone       = data.indexOf("so dien thoai")
  transactionColumn.totalCash   = data.indexOf("tong tien")
  transactionColumn.depositCash = data.indexOf("da tra")
  transactionColumn.debtDate    = data.indexOf("ngay tao")
  transactionColumn.description = data.indexOf("ly do")

  console.log transactionColumn

  (return transactionColumn = {} if value is -1) for key, value of transactionColumn
  transactionColumn


checkAndAddNewCustomer = (transactionColumn, data, profile) ->
  for item in data
    if !Schema.customers.findOne({
      parentMerchant: profile.parentMerchant
      name: item[transactionColumn.name]
      phone: item[transactionColumn.phone]
    })
      option =
        parentMerchant  : profile.parentMerchant
        currentMerchant : profile.currentMerchant
        creator         : profile.user
        name            : item[transactionColumn.name]
        gender          : if item[transactionColumn.gender] is 'Nam' or item[transactionColumn.gender] is 'nam' then true else false
        phone           : item[transactionColumn.phone]
        styles          : Helpers.RandomColor()

      if Schema.customers.findOne({
        currentMerchant: profile.parentMerchant
        name: item[transactionColumn.name]
        phone: item[transactionColumn.phone]
      }) then console.log 'Trùng tên khách hàng'
      else Schema.customers.insert option, (error, result) -> if error then console.log error
    MetroSummary.updateMetroSummaryBy(['customer'])

addTransactionAndDetail = (transactionColumn, data, profile) ->
  for item in data
    customer = Schema.customers.findOne({
      parentMerchant: profile.parentMerchant
      name: item[transactionColumn.name]
      phone: item[transactionColumn.phone]
    })
    Transaction.newByCustomer(
      customer._id,
      item[transactionColumn.description],
      item[transactionColumn.totalCash],
      item[transactionColumn.depositCash],
      moment(item[transactionColumn.debtDate], "DD/MM/YYYY")._d
    )

Apps.Merchant.transactionManagerInit.push (scope) ->
  scope.importFileTransactionCSV = (data)->
    profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    transactionColumn = checkValidationFileTransaction(data[0])
    if _.keys(transactionColumn).length > 0
      data = _.without(data, data[0])
      checkAndAddNewCustomer(transactionColumn, data, profile)
      addTransactionAndDetail(transactionColumn, data, profile)
