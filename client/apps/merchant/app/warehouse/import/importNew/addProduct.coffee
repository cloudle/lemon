lemon.defineWidget Template.addProduct,
  events:
    'click .create-product': (event, template)-> logics.import.createNewProduct(event, template)
    'click .delete-product': (event, template)-> logics.import.destroyNewProduct(@_id)



