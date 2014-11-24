resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")

logics.customerManagement.createNewCustomer = (context) ->
  fullName = context.ui.$fullName.val()
  pronoun = context.ui.$pronoun.val()
  description = context.ui.$description.val()

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