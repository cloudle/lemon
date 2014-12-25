Helpers.shortName = (fullName, maxlength = 6) ->
  return undefined if !fullName
  splited = fullName?.split(' ')
  name = splited[splited.length - 1]
  middle = splited[splited.length - 2]?.substring(0,1) if name.length < maxlength
  "#{if middle then middle + '.' else ''} #{name}"

Helpers.shortName2 = (fullName, word = 2) ->
  return undefined if !fullName
  splited = fullName?.split(' ')
  if word < 1 then word = 1
  if splited.length > word
    for i in [word..1]
      name += "#{splited[splited.length-i]}#{if i > 1 then ' ' else ''}"
    name
  else
    fullName

Helpers.respectName = (fullName, gender) -> "#{if gender then 'Anh' else 'Chị'} #{fullName.split(' ').pop()}"
Helpers.firstName = (fullName) -> fullName?.split(' ').pop()

Helpers.createSaleCode = ->
  date = new Date()
  day = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  oldSale = Schema.sales.findOne({'version.createdAt': {$gt: day}},{sort: {'version.createdAt': -1}})
  if oldSale
    code = Number(oldSale.orderCode.substring(oldSale.orderCode.length-4))+1
    if 99 < code < 999 then code = "0#{code}"
    if 9 < code < 100 then code = "00#{code}"
    if code < 10 then code = "000#{code}"
    orderCode = "#{Helpers.FormatDate()}-#{code}"
  else
    orderCode = "#{Helpers.FormatDate()}-0001"
  orderCode
