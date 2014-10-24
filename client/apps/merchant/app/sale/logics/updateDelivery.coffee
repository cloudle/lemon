logics.sales.updateDelivery = {}

logics.sales.updateDelivery.contactName = (event, template) ->
    contactName = template.find(".contactName").value
    if contactName.length > 1
      Sky.global.currentOrder.updateContactName(contactName.value)
    else contactName.value = Session.get('currentOrder').contactName

logics.sales.updateDelivery.contactPhone = (event, template) ->
    contactPhone = template.find(".contactPhone")
    if contactPhone.value.length > 1
      Sky.global.currentOrder.updateContactPhone(contactPhone.value)
    else contactPhone.value = Session.get('currentOrder').contactPhone

logics.sales.updateDelivery.deliveryAddress = (event, template) ->
    deliveryAddress = template.find(".deliveryAddress")
    if deliveryAddress.value.length > 1
      Sky.global.currentOrder.updateDeliveryAddress(deliveryAddress.value)
    else deliveryAddress.value = Session.get('currentOrder').deliveryAddress

logics.sales.updateDelivery.comment = (event, template) ->
    comment = template.find(".comment")
    if comment.value.length > 1
      Sky.global.currentOrder.updateComment(comment.value)
    else comment.value = Session.get('currentOrder').comment
