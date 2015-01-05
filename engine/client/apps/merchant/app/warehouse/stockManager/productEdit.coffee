lemon.defineWidget Template.productEdit,
  formatDate: (date) -> moment(date).format("DD/MM/YYYY")
  product: -> Session.get('currentProduct')
  updateProductPrice: -> !Session.get('updateProductPrice')
  showUpdateProductPrice: -> if Session.get('updateProductPrice') then 'display: block' else 'display: none'

  events:
    "click .cancelUpdateProductPrice": -> Session.set('updateProductPrice', false)
    "click .showUpdateProductPrice"  : -> Session.set('updateProductPrice', true)
    "click .updateProductPrice"      : ->
      if Session.get('currentProductPrice') > 0
        Schema.products.update(Session.get('currentProduct')._id , $set:{price: Session.get('currentProductPrice')})
        Session.set('currentProduct', Schema.products.findOne(Session.get('currentProduct')._id))
        Session.set('updateProductPrice', false)


  productPriceOptions:
    reactiveSetter: (val) -> Session.set('currentProductPrice', val)
    reactiveValue: -> Session.get('currentProduct')?.price ? 0
    reactiveMax: -> 9000000000
    reactiveMin: -> 0
    reactiveStep: -> 10000