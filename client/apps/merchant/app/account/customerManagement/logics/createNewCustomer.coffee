resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")

logics.customerManagement.createNewCustomer = (context) ->
  fullName = context.ui.$fullName.val()
  pronoun = context.ui.$pronoun.val()
  description = context.ui.$customerDescription.val()

  option =
    currentMerchant : Session.get('myProfile').currentMerchant
    parentMerchant  : Session.get('myProfile').parentMerchant
    creator         : Session.get('myProfile').user
    name            : fullName
    pronoun         : pronoun
    description     : description if description.length > 0
    gender          : Session.get('genderNewCustomer')
    styles          : Helpers.RandomColor()

  if Schema.customers.findOne({
    name: fullName
    description: description if description.length > 0
    currentMerchant: Session.get('myProfile').currentMerchant})
    context.ui.$fullName.notify("Trùng tên khách hàng", {position: "bottom"})
  else
    Schema.customers.insert option, (error, result) ->
      if error
        console.log error
      else
        MetroSummary.updateMetroSummaryBy(['customer'])
    resetForm(context)
    Session.set('allowCreateNewCustomer', false)

Apps.Merchant.customerManagementInit.push (scope) ->
  scope.createCustomer = (template) ->
    fullText    = Session.get("customerManagementSearchFilter")

    if fullText.indexOf("(") > 0
      namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
      descPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    else
      namePart    = fullText
      descPart    = ""

    console.log(namePart, descPart)
    customer =
      currentMerchant : Session.get('myProfile').currentMerchant
      parentMerchant  : Session.get('myProfile').parentMerchant
      creator         : Session.get('myProfile').user
      name            : namePart
      gender          : true
      styles          : Helpers.RandomColor()
    customer.description = descPart if descPart.length > 0

    existedQuery = {name: namePart, currentMerchant: Session.get('myProfile').currentMerchant}
    existedQuery.description = descPart if descPart.length > 0
    if Schema.customers.findOne existedQuery
      template.ui.$searchFilter.notify("Khách hàng đã tồn tại.", {position: "bottom"})
    else
      Schema.customers.insert customer, (error, result) ->
        console.log error if error
        MetroSummary.updateMetroSummaryBy(['customer'])
      template.ui.$searchFilter.val(''); Session.set("customerManagementSearchFilter", "")