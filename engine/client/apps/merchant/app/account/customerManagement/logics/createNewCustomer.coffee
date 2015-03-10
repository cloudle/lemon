#resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")
splitName = (fullText) ->
  if fullText.indexOf("(") > 0
    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
    descPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    return { name: namePart, description: descPart }
  else
    return { name: fullText }

#logics.customerManagement.createNewCustomer = (context) ->
#  fullName = context.ui.$fullName.val()
#  pronoun = context.ui.$pronoun.val()
#  description = context.ui.$customerDescription.val()
#
#  option =
#    currentMerchant : Session.get('myProfile').currentMerchant
#    parentMerchant  : Session.get('myProfile').parentMerchant
#    creator         : Session.get('myProfile').user
#    name            : fullName
#    pronoun         : pronoun
#    description     : description if description.length > 0
#    gender          : Session.get('genderNewCustomer')
#    styles          : Helpers.RandomColor()
#
#  if Schema.customers.findOne({
#    name: fullName
#    description: description if description.length > 0
#    currentMerchant: Session.get('myProfile').currentMerchant})
#    context.ui.$fullName.notify("Trùng tên khách hàng", {position: "bottom"})
#  else
#    Schema.customers.insert option, (error, result) ->
#      if error
#        console.log error
#      else
#        MetroSummary.updateMetroSummaryBy(['customer'])
#    resetForm(context)
#    Session.set('allowCreateNewCustomer', false)

Apps.Merchant.customerManagementInit.push (scope) ->
  scope.createCustomer = (template) ->
    fullText    = Session.get("customerManagementSearchFilter")
    nameOptions = splitName(fullText)

    customer =
      currentMerchant : Session.get('myProfile').currentMerchant
      parentMerchant  : Session.get('myProfile').parentMerchant
      merchant        : Session.get('myProfile').currentMerchant
      creator         : Session.get('myProfile').user
      name            : nameOptions.name
      gender          : true
      styles          : Helpers.RandomColor()
    customer.description = nameOptions.description if nameOptions.description

    existedQuery = {name: nameOptions.name, currentMerchant: Session.get('myProfile').currentMerchant}
    existedQuery.description = nameOptions.description if nameOptions.description?.length > 0
    if Schema.customers.findOne existedQuery
      template.ui.$searchFilter.notify("Khách hàng đã tồn tại.", {position: "bottom"})
    else
      Schema.customers.insert customer, (error, result) ->
        if error then console.log error
        else
          Meteor.call 'updateMetroSummaryBy', 'createCustomer', result
          UserSession.set('currentCustomerManagementSelection', result)

      template.ui.$searchFilter.val(''); Session.set("customerManagementSearchFilter", "")

  scope.editCustomer = (template) ->
    customer = Session.get("customerManagementCurrentCustomer")
    if customer and Session.get("customerManagementShowEditCommand")
      name    = template.ui.$customerName.val()
      phone   = template.ui.$customerPhone.val()
      address = template.ui.$customerAddress.val()

      return if name.replace("(", "").replace(")", "").trim().length < 2
      editOptions = splitName(name)
      editOptions.phone = phone if phone.length > 0
      editOptions.address = address if address.length > 0

      console.log editOptions

      if editOptions.name.length > 0
        customerFound = Schema.customers.findOne {name: editOptions.name, parentMerchant: customer.parentMerchant}

      if editOptions.name.length is 0
        template.ui.$customerName.notify("Tên khách hàng không thể để trống.", {position: "right"})
      else if customerFound and customerFound._id isnt customer._id
        template.ui.$customerName.notify("Tên khách hàng đã tồn tại.", {position: "right"})
        template.ui.$customerName.val editOptions.name
        Session.set("customerManagementShowEditCommand", false)
      else
        Schema.customers.update customer._id, {$set: editOptions}, (error, result) -> if error then console.log error
        template.ui.$customerName.val editOptions.name
        Session.set("customerManagementShowEditCommand", false)



#    newName  = template.ui.$customerName.val()
#    newPhone = template.ui.$customerPhone.val()
#    newAddress = template.ui.$customerAddress.val()
#    return if newName.replace("(", "").replace(")", "").trim().length < 2
#    editOptions = splitName(newName)
#    editOptions.phone = newPhone if newPhone.length > 0
#    editOptions.address = newAddress if newAddress.length > 0
#
#    template.ui.$customerName.val editOptions.name
#    Session.set "customerManagementShowEditCommand", false
#
#    Schema.customers.update Session.get("customerManagementCurrentCustomer")._id, {$set: editOptions}, (error, result) ->
#      if error then console.log error else template.ui.$customerName.val Session.get("customerManagementCurrentCustomer").name
