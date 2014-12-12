#resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")
splitName = (fullText) ->
  if fullText.indexOf("(") > 0
    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
    descPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    return { name: namePart, description: descPart }
  else
    return { name: fullText }

#logics.staffManagement.createNewStaff = (context) ->
#  fullName = context.ui.$fullName.val()
#  pronoun = context.ui.$pronoun.val()
#  description = context.ui.$staffDescription.val()
#
#  option =
#    currentMerchant : Session.get('myProfile').currentMerchant
#    parentMerchant  : Session.get('myProfile').parentMerchant
#    creator         : Session.get('myProfile').user
#    name            : fullName
#    pronoun         : pronoun
#    description     : description if description.length > 0
#    gender          : Session.get('genderNewStaff')
#    styles          : Helpers.RandomColor()
#
#  if Schema.staffs.findOne({
#    name: fullName
#    description: description if description.length > 0
#    currentMerchant: Session.get('myProfile').currentMerchant})
#    context.ui.$fullName.notify("Trùng tên khách hàng", {position: "bottom"})
#  else
#    Schema.staffs.insert option, (error, result) ->
#      if error
#        console.log error
#      else
#        MetroSummary.updateMetroSummaryBy(['staff'])
#    resetForm(context)
#    Session.set('allowCreateNewStaff', false)

Apps.Merchant.staffManagementInit.push (scope) ->
  scope.createStaff = (template) ->
    fullText    = Session.get("staffManagementSearchFilter")
    nameOptions = splitName(fullText)

    staff =
      currentMerchant : Session.get('myProfile').currentMerchant
      parentMerchant  : Session.get('myProfile').parentMerchant
      creator         : Session.get('myProfile').user
      name            : nameOptions.name
      gender          : true
      styles          : Helpers.RandomColor()
    staff.description = nameOptions.description if nameOptions.description

    existedQuery = {name: nameOptions.name, currentMerchant: Session.get('myProfile').currentMerchant}
    existedQuery.description = nameOptions.description if nameOptions.description?.length > 0
    if Schema.staffs.findOne existedQuery
      template.ui.$searchFilter.notify("Khách hàng đã tồn tại.", {position: "bottom"})
    else
      Schema.staffs.insert staff, (error, result) ->
        console.log error if error
        MetroSummary.updateMetroSummaryBy(['staff'])
        UserSession.set('currentStaffManagementSelection', result)
      template.ui.$searchFilter.val(''); Session.set("staffManagementSearchFilter", "")

  scope.editStaff = (template) ->
    staff = Session.get("staffManagementCurrentStaff")
    if staff and Session.get("staffManagementShowEditCommand")
      name    = template.ui.$staffName.val()
      phone   = template.ui.$staffPhone.val()
      address = template.ui.$staffAddress.val()

      return if name.replace("(", "").replace(")", "").trim().length < 2
      editOptions = splitName(name)
      editOptions.phone = phone if phone.length > 0
      editOptions.address = address if address.length > 0

      console.log editOptions

      if editOptions.name.length > 0
        staffFound = Schema.staffs.findOne {name: editOptions.name, parentMerchant: staff.parentMerchant}

      if editOptions.name.length is 0
        template.ui.$staffName.notify("Tên khách hàng không thể để trống.", {position: "right"})
      else if staffFound and staffFound._id isnt staff._id
        template.ui.$staffName.notify("Tên khách hàng đã tồn tại.", {position: "right"})
        template.ui.$staffName.val editOptions.name
        Session.set("staffManagementShowEditCommand", false)
      else
        Schema.staffs.update staff._id, {$set: editOptions}, (error, result) -> if error then console.log error
        template.ui.$staffName.val editOptions.name
        Session.set("staffManagementShowEditCommand", false)



#    newName  = template.ui.$staffName.val()
#    newPhone = template.ui.$staffPhone.val()
#    newAddress = template.ui.$staffAddress.val()
#    return if newName.replace("(", "").replace(")", "").trim().length < 2
#    editOptions = splitName(newName)
#    editOptions.phone = newPhone if newPhone.length > 0
#    editOptions.address = newAddress if newAddress.length > 0
#
#    template.ui.$staffName.val editOptions.name
#    Session.set "staffManagementShowEditCommand", false
#
#    Schema.staffs.update Session.get("staffManagementCurrentStaff")._id, {$set: editOptions}, (error, result) ->
#      if error then console.log error else template.ui.$staffName.val Session.get("staffManagementCurrentStaff").name
