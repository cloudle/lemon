Schema.add "buildInProducts", "BuildInProduct", class BuildInProduct
  @name: "BuildIn Product"

  @optionByProduct: (product) ->
    option =
      product     : product._id
      creator     : Meteor.userId()
      name        : product.name
      basicUnit   : product.basicUnit
      productCode : product.productCode
      image       : product.image if product.image
      description : product.description if product.description
      status      : 'copy'
    return option