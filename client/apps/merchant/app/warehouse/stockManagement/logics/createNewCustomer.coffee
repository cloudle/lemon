#resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")
#splitName = (fullText) ->
#  if fullText.indexOf("(") > 0
#    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
#    descPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
#  else
#    namePart    = fullText
#    descPart    = ""
#
#  return { name: namePart, description: descPart }
#
#
#logics.stockManagement.createNewStock = (context) ->
#  fullName = context.ui.$fullName.val()
#  pronoun = context.ui.$pronoun.val()
#  description = context.ui.$stockDescription.val()
#
#  option =
#    currentMerchant : Session.get('myProfile').currentMerchant
#    parentMerchant  : Session.get('myProfile').parentMerchant
#    creator         : Session.get('myProfile').user
#    name            : fullName
#    pronoun         : pronoun
#    description     : description if description.length > 0
#    gender          : Session.get('genderNewStock')
#    styles          : Helpers.RandomColor()
#
#  if Schema.stocks.findOne({
#    name: fullName
#    description: description if description.length > 0
#    currentMerchant: Session.get('myProfile').currentMerchant})
#    context.ui.$fullName.notify("Trùng tên khách hàng", {position: "bottom"})
#  else
#    Schema.stocks.insert option, (error, result) ->
#      if error
#        console.log error
#      else
#        MetroSummary.updateMetroSummaryBy(['stock'])
#    resetForm(context)
#    Session.set('allowCreateNewStock', false)
#
#Apps.Merchant.stockManagementInit.push (scope) ->
#  scope.createStock = (template) ->
#    fullText    = Session.get("stockManagementSearchFilter")
#    nameOptions = splitName(fullText)
#
#    stock =
#      currentMerchant : Session.get('myProfile').currentMerchant
#      parentMerchant  : Session.get('myProfile').parentMerchant
#      creator         : Session.get('myProfile').user
#      name            : nameOptions.name
#      description     : nameOptions.description
#      gender          : true
#      styles          : Helpers.RandomColor()
#
#    existedQuery = {name: nameOptions.name, currentMerchant: Session.get('myProfile').currentMerchant}
#    existedQuery.description = nameOptions.description if nameOptions.description.length > 0
#    if Schema.stocks.findOne existedQuery
#      template.ui.$searchFilter.notify("Khách hàng đã tồn tại.", {position: "bottom"})
#    else
#      Schema.stocks.insert stock, (error, result) ->
#        console.log error if error
#        MetroSummary.updateMetroSummaryBy(['stock'])
#      template.ui.$searchFilter.val(''); Session.set("stockManagementSearchFilter", "")
#
#  scope.editStock = (template) ->
#    newName  = template.ui.$stockName.val()
#    newPhone = template.ui.$stockPhone.val()
#    newAddress = template.ui.$stockAddress.val()
#    return if newName.replace("(", "").replace(")", "").trim().length < 2
#    editOptions = splitName(newName)
#    editOptions.phone = newPhone if newPhone.length > 0
#    editOptions.address = newAddress if newAddress.length > 0
#
#    template.ui.$stockName.val editOptions.name
#    Session.set "stockManagementShowEditCommand", false
#
#    Schema.stocks.update Session.get("stockManagementCurrentStock")._id, {$set: editOptions}, (error, result) ->
#      if error then console.log error else template.ui.$stockName.val Session.get("stockManagementCurrentStock").name