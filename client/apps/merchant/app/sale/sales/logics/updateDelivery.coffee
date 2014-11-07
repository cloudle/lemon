Apps.Merchant.salesInit.push ->
  logics.sales.updateDeliveryContactName = (contactName) ->
    if logics.sales.currentOrder
      if contactName.length > 1
        Order.update(logics.sales.currentOrder._id, {$set: {contactName: contactName}})
      else contactName.value = logics.sales.currentOrder.contactName

  logics.sales.updateDeliveryContactPhone = (contactPhone) ->
    if logics.sales.currentOrder
      if contactPhone.length > 1
        Order.update(logics.sales.currentOrder._id, {$set: {contactPhone: contactPhone}})
      else contactPhone.value = logics.sales.currentOrder.contactPhone

  logics.sales.updateDeliveryAddress = (deliveryAddress) ->
    if logics.sales.currentOrder
      if deliveryAddress.length > 1
        Order.update(logics.sales.currentOrder._id, {$set: {deliveryAddress: deliveryAddress}})
      else deliveryAddress.value = logics.sales.currentOrder.deliveryAddress

  logics.sales.updateDeliveryComment = (comment) ->
    if logics.sales.currentOrder
      if comment.length > 1
        Order.update(logics.sales.currentOrder._id, {$set: {comment: comment}})
      else comment.value = logics.sales.currentOrder.comment