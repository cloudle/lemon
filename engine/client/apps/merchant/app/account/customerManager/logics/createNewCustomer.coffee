resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")

logics.customerManager.createNewCustomer = (context) ->
  fullName = context.ui.$fullName.val()
  pronoun = context.ui.$pronoun.val()
  description = context.ui.$description.val()
  phone = context.ui.$phone.val()
  address = context.ui.$address.val()
  dateOfBirth = $("[name=dateOfBirth]").datepicker().data().datepicker.dates[0]
  #  dateOfBirth = context.ui.$dateOfBirth.data('datepicker').dates[0]

  areas = []
  if Session.get('currentRoleSelection')?.length > 0
    areas.push area._id for area in Session.get('currentCustomerAreaSelection')

  option =
    currentMerchant : Session.get('myProfile').currentMerchant
    parentMerchant  : Session.get('myProfile').parentMerchant
    creator         : Session.get('myProfile').user
    name            : fullName
    pronoun         : pronoun
    phone           : phone
    address         : address
    description     : description if description.length > 0
    dateOfBirth     : dateOfBirth
    areas           : areas if areas.length > 0
    gender          : Session.get('genderNewCustomer')
    styles          : Helpers.RandomColor()

  if Schema.customers.findOne({
    name: fullName
    description: description if description.length > 0
    currentMerchant: Session.get('myProfile').currentMerchant})
    console.log 'Trùng tên khách hàng'
  else
    Schema.customers.insert option, (error, result) ->
      if error
        console.log error
      else
        MetroSummary.updateMetroSummaryBy(['customer'])
    resetForm(context)
    Session.set('allowCreateNewCustomer', false)