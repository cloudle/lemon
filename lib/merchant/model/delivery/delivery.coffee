Schema.add 'deliveries', "Delivery", class Delivery
  @newBySale: (order, sale)->
    option =
      merchant        : sale.merchant
      warehouse       : sale.warehouse
      creator         : sale.creator
      sale            : sale._id
      buyer           : sale.buyer
      contactName     : order.contactName
      contactPhone    : order.contactPhone
      deliveryAddress : order.deliveryAddress
      comment         : order.comment
      status          : 0

    option.deliveryDate = order.deliveryDate if order.deliveryDate
    option


  @insertBySale: (order, sale)-> @schema.insert Delivery.newBySale(order, sale)



