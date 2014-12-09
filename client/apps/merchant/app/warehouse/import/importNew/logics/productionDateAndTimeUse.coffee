#Apps.Merchant.importInit.push (scope) ->
#  logics.import.getExpireDate = ()->
#    expire = $("[name=expire]").datepicker().data().datepicker.dates[0]
#    if expire > (new Date)
#      expireDate = new Date(expire.getFullYear(), expire.getMonth(), expire.getDate())
#    else null
#
#  logics.import.getProductionDate = ()->
#    productionDate = $("[name=productionDate]").datepicker().data().datepicker.dates[0]
#    if productionDate and (productionDate < (new Date))
#      new Date(productionDate.getFullYear(), productionDate.getMonth(), productionDate.getDate())
#    else
#      null