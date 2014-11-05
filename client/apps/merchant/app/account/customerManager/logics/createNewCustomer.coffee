resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")

logics.customerManager.createNewCustomer = (context) ->
  fullName = context.ui.$fullName.val()
  phone = context.ui.$phone.val()
  address = context.ui.$address.val()
  dateOfBirth = $("[name=dateOfBirth]").datepicker().data().datepicker.dates[0]
  #  dateOfBirth = context.ui.$dateOfBirth.data('datepicker').dates[0]
  console.log dateOfBirth

  option =
    creator: Meteor.userId()
    name: fullName
    phone: phone
    address: address
    dateOfBirth: dateOfBirth
    styles          : Helpers.RandomColor()
    currentMerchant : Session.get('myProfile').currentMerchant
    parentMerchant  : Session.get('myProfile').parentMerchant
    gender          : Session.get('genderNewCustomer')

  if Schema.customers.findOne({
    name: fullName
    phone: phone
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