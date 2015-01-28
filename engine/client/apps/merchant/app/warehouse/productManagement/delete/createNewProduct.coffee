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
#logics.productManagement.createNewProduct = (context) ->
#  fullName = context.ui.$fullName.val()
#  pronoun = context.ui.$pronoun.val()
#  description = context.ui.$productDescription.val()
#
#  option =
#    currentMerchant : Session.get('myProfile').currentMerchant
#    parentMerchant  : Session.get('myProfile').parentMerchant
#    creator         : Session.get('myProfile').user
#    name            : fullName
#    pronoun         : pronoun
#    description     : description if description.length > 0
#    gender          : Session.get('genderNewProduct')
#    styles          : Helpers.RandomColor()
#
#  if Schema.products.findOne({
#    name: fullName
#    description: description if description.length > 0
#    currentMerchant: Session.get('myProfile').currentMerchant})
#    context.ui.$fullName.notify("Trùng tên khách hàng", {position: "bottom"})
#  else
#    Schema.products.insert option, (error, result) ->
#      if error
#        console.log error
#      else
#        MetroSummary.updateMetroSummaryBy(['product'])
#    resetForm(context)
#    Session.set('allowCreateNewProduct', false)
#
#Apps.Merchant.productManagementInit.push (scope) ->
#  scope.createProduct = (template) ->
#    fullText    = Session.get("productManagementSearchFilter")
#    nameOptions = splitName(fullText)
#
#    product =
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
#    if Schema.products.findOne existedQuery
#      template.ui.$searchFilter.notify("Khách hàng đã tồn tại.", {position: "bottom"})
#    else
#      Schema.products.insert product, (error, result) ->
#        console.log error if error
#        MetroSummary.updateMetroSummaryBy(['product'])
#      template.ui.$searchFilter.val(''); Session.set("productManagementSearchFilter", "")
#
#  scope.editProduct = (template) ->
#    newName  = template.ui.$productName.val()
#    newPhone = template.ui.$productPhone.val()
#    newAddress = template.ui.$productAddress.val()
#    return if newName.replace("(", "").replace(")", "").trim().length < 2
#    editOptions = splitName(newName)
#    editOptions.phone = newPhone if newPhone.length > 0
#    editOptions.address = newAddress if newAddress.length > 0
#
#    template.ui.$productName.val editOptions.name
#    Session.set "productManagementShowEditCommand", false
#
#    Schema.products.update Session.get("productManagementCurrentProduct")._id, {$set: editOptions}, (error, result) ->
#      if error then console.log error else template.ui.$productName.val Session.get("productManagementCurrentProduct").name