Schema.add 'deliveries', class Delivery
  @newBySale: (order, sale)->
    option =
      merchant        : sale.merchant
      warehouse       : sale.warehouse
      creator         : sale.creator
      sale            : sale._id
      contactName     : order.contactName
      contactPhone    : order.contactPhone
      deliveryAddress : order.deliveryAddress
      comment         : order.comment
      deliveryDate    : order.deliveryDate if order.deliveryDate
      status          : 0

  @insertBySale: (order, sale)-> @schema.insert Delivery.newBySale(order, sale), (error, result) -> if error then error else result


