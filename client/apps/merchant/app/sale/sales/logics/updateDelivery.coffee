Apps.Merchant.salesInit.push ->
  logics.sales.updateDeliveryContactName = (contactName) ->
    if Session.get('currentOrder')
      if contactName.value.length > 1
        Order.update(Session.get('currentOrder')._id, {$set: {contactName: contactName.value}})
      else contactName.value = Session.get('currentOrder').contactName

  logics.sales.updateDeliveryContactPhone = (contactPhone) ->
    if Session.get('currentOrder')
      if contactPhone.value.length > 1
        Order.update(Session.get('currentOrder')._id, {$set: {contactPhone: contactPhone.value}})
      else contactPhone.value = Session.get('currentOrder').contactPhone

  logics.sales.updateDeliveryAddress = (deliveryAddress) ->
    if Session.get('currentOrder')
      if deliveryAddress.value.length > 1
        Order.update(Session.get('currentOrder')._id, {$set: {deliveryAddress: deliveryAddress.value}})
      else deliveryAddress.value = Session.get('currentOrder').deliveryAddress

  logics.sales.updateDeliveryComment = (comment) ->
    if Session.get('currentOrder')
      if comment.value.length > 1
        Order.update(Session.get('currentOrder')._id, {$set: {comment: comment.value}})
      else comment.value = Session.get('currentOrder').comment

  logics.sales.updateDeliveryDate = () ->
    if Session.get('currentOrder')?.paymentsDelivery
      date = $("[name=deliveryDate]").datepicker().data().datepicker.dates[0]
      toDate = new Date
      if date
        deliveryToDate = new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate())
        deliveryDate = new Date(date.getFullYear(), date.getMonth(), date.getDate())
        if deliveryDate < deliveryToDate
          deliveryDate = deliveryToDate; $("[name=deliveryDate]").datepicker('setDate', deliveryDate)
      else
        date = toDate; $("[name=deliveryDate]").datepicker('setDate', date)
      deliveryDate = new Date(date.getFullYear(), date.getMonth(), date.getDate()) if !deliveryDate

      if Session.get('currentOrder').deliveryDate.toDateString() != deliveryDate.toDateString()
        Session.get('currentOrder').deliveryDate = deliveryDate
        Schema.orders.update(Session.get('currentOrder')._id, {$set: {deliveryDate: deliveryDate}})
