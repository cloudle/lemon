Schema.add "buildInProductUnits", "BuildInProductUnit", class BuildInProductUnit
  @name: "BuildIn Product Unit"

  @optionByProductUnit: (buildInProductId, productUnit) ->
    option =
      buildInProduct   : buildInProductId
      productCode      : productUnit.productCode
      image            : productUnit.image if productUnit.image
      unit             : productUnit.unit
      conversionQuality: productUnit.conversionQuality
      creator          : Meteor.userId()
    return option