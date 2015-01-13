@Helpers = {}
Apps.Home = {}
Apps.Merchant = {}

Helpers.shortName = (fullName, maxlength = 6) ->
  return undefined if !fullName
  splited = fullName?.split(' ')
  name = splited[splited.length - 1]
  middle = splited[splited.length - 2]?.substring(0,1) if name.length < maxlength
  "#{if middle then middle + '.' else ''} #{name}"

Helpers.shortName2 = (fullName, word = 2) ->
  return undefined if !fullName
  splited = fullName?.split(' ')
  name = ""
  if word < 1 then word = 1
  if splited.length > word
    for i in [word..1]
      name += "#{splited[splited.length-i]}#{if i > 1 then ' ' else ''}"
    name
  else
    fullName

Helpers.respectName = (fullName, gender) -> "#{if gender then 'Anh' else 'Chị'} #{fullName.split(' ').pop()}"
Helpers.firstName = (fullName) -> fullName?.split(' ').pop()

Helpers.Number = (numberText) -> number = Number(numberText); if isNaN(number) then number = 0 else Math.floor(number)

Helpers.createSaleCode = (buyerId)->
#  date = new Date()
#  day = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  oldSale = Schema.sales.findOne({buyer: buyerId},{sort: {'version.createdAt': -1}})
#  oldSale = Schema.sales.findOne({buyer: buyerId, 'version.createdAt': {$gt: day}},{sort: {'version.createdAt': -1}})
  if oldSale
    code = Number(oldSale.orderCode.substring(oldSale.orderCode.length-4))+1
    if 99 < code < 999 then code = "0#{code}"
    if 9 < code < 100 then code = "00#{code}"
    if code < 10 then code = "000#{code}"
    orderCode = "#{code}"
#    orderCode = "#{Helpers.FormatDate()}-#{code}"
  else
    orderCode = "0001"
#    orderCode = "#{Helpers.FormatDate()}-0001"
  orderCode

Helpers.orderCodeCreate = (text)->
  code = Number(text)+1
  if 99 < code < 999 then code = "0#{code}"
  if 9 < code < 100 then code = "00#{code}"
  if code < 10 then code = "000#{code}"
  return code

colors = ['green', 'light-green', 'yellow', 'orange', 'blue', 'dark-blue', 'lime', 'pink', 'red', 'purple', 'dark',
          'gray', 'magenta', 'teal', 'turquoise', 'green-sea', 'emeral', 'nephritis', 'peter-river', 'belize-hole',
          'amethyst', 'wisteria', 'wet-asphalt', 'midnight-blue', 'sun-flower', 'carrot', 'pumpkin', 'alizarin',
          'pomegranate', 'clouds', 'sky', 'silver', 'concrete', 'asbestos']
monoColors = ['green', 'light-green', 'yellow', 'orange', 'blue', 'dark-blue', 'lime', 'pink', 'red', 'purple', 'dark',
              'gray', 'magenta', 'teal', 'turquoise', 'green-sea', 'emeral', 'nephritis', 'peter-river', 'belize-hole',
              'amethyst', 'wisteria', 'wet-asphalt', 'midnight-blue', 'sun-flower', 'carrot', 'pumpkin', 'alizarin',
              'pomegranate', 'clouds', 'sky', 'silver', 'concrete', 'asbestos']

colorGenerateHistory = []

generateRandomIndex = -> Math.floor(Math.random() * monoColors.length)

Helpers.RandomColor = ->
  if colorGenerateHistory.length >= monoColors.length
    colorGenerateHistory = []

  while true
    randomIndex = generateRandomIndex()
    colorExisted = _.contains(colorGenerateHistory, randomIndex)
    break unless colorExisted

  colorGenerateHistory.push randomIndex
  monoColors[randomIndex]

Helpers.ColorBetween = (r1, g1, b1, r2, g2, b2, percent, disortion = 1) ->
  disortedPercent = percent * disortion
  disortedPercent = 1 if disortedPercent > 1

  deltaR = Math.round(Math.abs(r1 - r2) * disortedPercent)
  deltaG = Math.round(Math.abs(g1 - g2) * disortedPercent)
  deltaB = Math.round(Math.abs(b1 - b2) * disortedPercent)

  multatorR = if r1 < r2 then 1 else -1
  multatorG = if g1 < g2 then 1 else -1
  multatorB = if b1 < b2 then 1 else -1

  return "rgb(#{r1 + deltaR * multatorR}, #{g1 + deltaG * multatorG}, #{b1 + deltaB * multatorB})"
Helpers.FormatDate = (format = 0, dateObj = new Date())->
  curr_Day   = dateObj.getDate()
  curr_Month = dateObj.getMonth()+1
  curr_Tear  = dateObj.getFullYear().toString()
  if curr_Day < 10 then curr_Day = "0#{curr_Day}"
  if curr_Month < 10 then curr_Month = "0#{curr_Month}"
  switch format
    when 0 then "#{curr_Day}#{curr_Month}#{curr_Tear.substring(2,4)}"
    when 1 then "#{curr_Day}-#{curr_Month}-#{curr_Tear}"
Helpers.RemoveVnSigns = (source) ->
  str = source

  str = str.toLowerCase();
  str = str.replace /à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a"
  str = str.replace /è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e"
  str = str.replace /ì|í|ị|ỉ|ĩ/g, "i"
  str = str.replace /ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o"
  str = str.replace /ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u"
  str = str.replace /ỳ|ý|ỵ|ỷ|ỹ/g, "y"
  str = str.replace /đ/g, "d"

  str = str.replace /!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'| |\"|\&|\#|\[|\]|~|$|_/g, "-" # tìm và thay thế các kí tự đặc biệt trong chuỗi sang kí tự -
  str = str.replace /-+-/g, "-" #thay thế 2- thành 1-
  str = str.replace /^\-+|\-+$/g, "" #cắt bỏ ký tự - ở đầu và cuối chuỗi
  str

Helpers.deferredAction = (action, uniqueName, timeOut = 200) ->
  Meteor.clearTimeout(Apps.currentDefferedTimeout) if Apps.currentDefferedActionName is uniqueName

  Apps.currentDefferedTimeout = Meteor.setTimeout ->
    action()
  , timeOut

  Apps.currentDefferedActionName = uniqueName if uniqueName
Helpers.animateUsing = (selector, animationType) ->
  $element = $(selector)
  $element.removeClass()
  .addClass("animated #{animationType}")
  .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', -> $element.removeClass())

Helpers.excuteAfterAnimate = ($element, pureClass, animationType, commands) ->
  $element.removeClass()
  .addClass("#{pureClass} animated #{animationType}")
  .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', -> commands())

Helpers.arrangeAppLayout = Component.helpers.arrangeAppLayout
Helpers.isEmail = (email)->
  reg = /^\w+[\+\.\w-]*@([\w-]+\.)*\w+[\w-]*\.([a-z]{2,4}|\d+)$/i
#  reg1= /^[0-9A-Za-z]+[0-9A-Za-z_]*@[\w\d.]+.\w{2,4}$/
  reg.test(email)

Helpers.randomBarcode = (prefix="0", length=10)->
  for i in [0...length]
    prefix += Math.floor(Math.random() * 10)

  prefix