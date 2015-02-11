Apps.Merchant.partnerManagementInit.push (scope) ->
  scope.checkAllowUpdatePartnerOverview = (template) ->
    Session.set "partnerManagementShowEditCommand",
      template.ui.$partnerName.val() isnt Session.get("partnerManagementCurrentPartner").name or
      template.ui.$partnerPhone.val() isnt (Session.get("partnerManagementCurrentPartner").phone ? '') or
      template.ui.$partnerAddress.val() isnt (Session.get("partnerManagementCurrentPartner").address ? '')

  scope.editPartner = (template) ->
    partner = Session.get("partnerManagementCurrentPartner")
    if partner and Session.get("partnerManagementShowEditCommand")
      name    = template.ui.$partnerName.val()
      phone   = template.ui.$partnerPhone.val()
      address = template.ui.$partnerAddress.val()

      editOptions = {}
      editOptions.phone = phone if phone.length > 0
      editOptions.address = address if address.length > 0

      if name.length > 0
        editOptions.name = name
        partnerFound = Schema.partners.findOne {name: name, parentMerchant: partner.parentMerchant}

      if name.length is 0
        template.ui.$partnerName.notify("Tên đối tác không thể để trống.", {position: "right"})
      else if partnerFound and partnerFound._id isnt partner._id
        template.ui.$partnerName.notify("Tên đối tác đã tồn tại.", {position: "right"})
        template.ui.$partnerName.val name
        Session.set("partnerManagementShowEditCommand", false)
      else
        Schema.partners.update partner._id, {$set: editOptions}, (error, result) -> if error then console.log error
        template.ui.$partnerName.val editOptions.name
      Session.set("partnerManagementCurrentPartner", Schema.partners.findOne(partner._id))
      Session.set("partnerManagementShowEditCommand", false)

  scope.keyupCheckEditPartner = (event, template) ->
    if event.which is 27
      if $(event.currentTarget).attr('name') is 'partnerName'
        $(event.currentTarget).val(Session.get("partnerManagementCurrentPartner").name)
        $(event.currentTarget).change()
      else if $(event.currentTarget).attr('name') is 'partnerPhone'
        $(event.currentTarget).val(Session.get("partnerManagementCurrentPartner").phone)
        $(event.currentTarget).change()
      else if $(event.currentTarget).attr('name') is 'partnerAddress'
        $(event.currentTarget).val(Session.get("partnerManagementCurrentPartner").address)
        $(event.currentTarget).change()
    scope.editPartner(template) if event.which is 13
    scope.checkAllowUpdatePartnerOverview(template)