logics.sales.validation = {}

logics.sales.validation.orderDetail = (order)->
  unless product = Schema.products.findOne(order.currentProduct)
    console.log 'Chưa chọn sản phẩm'
    return false
  else if order.currentQuality == 0
    console.log 'Số lượng phải lớn hơn 0'
    return false
  else if order.currentPrice == 0
    console.log 'Giá sản phẩm phải lớn hơn 0'
    return false
  else if order.currentPrice < product.price
    console.log 'Giá sản phẩm phải lớn hơn giá nhập'
    return false
  else
    return true

logics.sales.validation.checkProductInStockQuality = (order, orderDetails)->
  product_ids = _.union(_.pluck(orderDetails, 'product'))
  products = Schema.products.find({_id: {$in: product_ids}}).fetch()

  orderDetails = _.chain(orderDetails)
  .groupBy("product")
  .map (group, key) ->
    return {
    product: key
    quality: _.reduce(group, ((res, current) -> res + current.quality), 0)
    }
  .value()
  try
    for currentDetail in orderDetails
      currentProduct = _.findWhere(products, {_id: currentDetail.product})
      if currentProduct.availableQuality < currentDetail.quality
        throw {message: "lỗi", item: currentDetail}

    return {}
  catch e
    return {error: e}