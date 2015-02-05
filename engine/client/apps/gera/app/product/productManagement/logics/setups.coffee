splitName = (fullText) ->
  if fullText.indexOf("(") > 0
    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
    basicUnitPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    return { name: namePart, basicUnit: basicUnitPart }
  else
    return { name: fullText }

formatProductGroupSearch = (item) ->
  if item
    name = "#{item.name} "
#    desc = if item.description then "(#{item.description})" else ""
#    name + desc

#changedActionSelectProductGroup = (currentProductGroup)->
#  UserSession.set 'currentGeraProductManagementSelectionProductGroup', currentProductGroup._id

Apps.Gera.productManagementInit.push (scope) ->
#  scope.productGroupSelectOptions =
#    query: (query) -> query.callback
#      results: _.filter Schema.productGroups.find({buildIn: true}).fetch(), (item) ->
#        unsignedTerm = Helpers.RemoveVnSigns query.term
#        unsignedName = Helpers.RemoveVnSigns item.name
#
#        unsignedName.indexOf(unsignedTerm) > -1
#      text: 'name'
#    initSelection: (element, callback) -> callback(Session.get("mySession").currentGeraProductManagementSelectionProductGroup)
#    formatSelection: formatProductGroupSearch
#    formatResult: formatProductGroupSearch
#    id: '_id'
#    placeholder: 'CHỌN NHÓM SẢN PHẨM'
#    changeAction: (e) -> changedActionSelectProductGroup(e.added)
#    reactiveValueGetter: -> Session.get("mySession")?.currentGeraProductManagementSelectionProductGroup

  scope.createGeraProduct = (template)->
    fullText    = Session.get("geraProductManagementSearchFilter")
    nameOptions = splitName(fullText)

    product =
      creator       : Session.get('myProfile').user
      name          : nameOptions.name
      styles        : Helpers.RandomColor()
    product.basicUnit = nameOptions.basicUnit if nameOptions.basicUnit

    existedQuery = {name: product.name}
    if Schema.buildInProducts.findOne(existedQuery)
      template.ui.$searchFilter.notify("Sản phẩm đã tồn tại.", {position: "bottom"})
    else
      while true
        randomBarcode = Helpers.randomBarcode()
        existedQuery.productCode = randomBarcode

        if !Schema.buildInProducts.findOne(existedQuery)
          product.productCode = randomBarcode
          productId = Schema.buildInProducts.insert product, (error, result) -> console.log error if error

          UserSession.set('currentGeraProductManagementSelection', productId)
          template.ui.$searchFilter.val('')
          Session.set("geraProductManagementSearchFilter", "")
          break

  scope.checkAndUpdateGeraProduct = (event, template, geraProduct)->
    if event.which is 27
      if $(event.currentTarget).attr('name') is 'productName'
        $(event.currentTarget).val(Session.get("geraProductManagementCurrentProduct").name)
        $(event.currentTarget).change()
      else if $(event.currentTarget).attr('name') is 'description'
        $(event.currentTarget).val(Session.get("geraProductManagementCurrentProduct").description)
      else if $(event.currentTarget).attr('name') is 'productCode'
        $(event.currentTarget).val(Session.get("geraProductManagementCurrentProduct").productCode)
    else if event.which is 13
      scope.updateGeraProduct(template, geraProduct)

    Session.set "geraProductManagementShowEditCommand",
      template.ui.$productName.val() isnt Session.get("geraProductManagementCurrentProduct").name or
      template.ui.$description.val() isnt Session.get("geraProductManagementCurrentProduct").description or
      template.ui.$productCode.val() isnt Session.get("geraProductManagementCurrentProduct").productCode

  scope.updateGeraProduct = (template, geraProduct) ->
      newName  = template.ui.$productName.val()
      newProductCode = template.ui.$productCode.val()
      newDescription = template.ui.$description.val()
      return if newName.replace("(", "").replace(")", "").trim().length < 2
      editOptions = splitName(newName)
      editOptions.productCode = newProductCode if newProductCode.length > 0
      editOptions.description = newDescription if newDescription.length > 0

      productFound = Schema.buildInProducts.findOne {name: editOptions.name} if editOptions.name.length > 0
      barcodeFound = Schema.buildInProducts.findOne {productCode: newProductCode} if newProductCode.length > 0

      if editOptions.name.length is 0
        template.ui.$productName.notify("Tên sản phẩn không thể để trống.", {position: "right"})
      else if productFound and productFound._id isnt geraProduct._id
        template.ui.$productName.notify("Tên sản phẩm đã tồn tại.", {position: "right"})
      else if barcodeFound and barcodeFound._id isnt geraProduct._id
        template.ui.$productCode.notify("Mã sản phẩm đã tồn tại.", {position: "right"})
      else
        if Schema.productUnits.findOne({product: geraProduct._id})
          delete editOptions.basicUnit
          Schema.buildInProducts.update geraProduct._id, {$set: editOptions}, (error, result) -> if error then console.log error
        else
          Schema.buildInProducts.update geraProduct._id, {$set: editOptions}, (error, result) -> if error then console.log error

        template.ui.$productName.val editOptions.name
        Session.set("geraProductManagementShowEditCommand", false)


  scope.deleteGeraProduct = (geraProduct) ->
    if geraProduct.status is 'brandNew' || geraProduct.status is 'copy'
      Meteor.call 'deleteBuildInProduct', geraProduct._id, (error, result) ->
        if error then console.log error
        else
          currentGeraProduct = Schema.buildInProducts.findOne()?._id ? ''
          UserSession.set 'currentGeraProductManagementSelection', currentGeraProduct

  scope.submitGeraProduct = (geraProduct) ->
    if geraProduct.status is 'copy'
      Meteor.call 'submitBuildInProduct', geraProduct._id, (error, result) -> if error then console.log error



  scope.createGeraProductUnit = (geraProduct)->
    #TODO: Chinh lai truong hop bi trung randomBarcode()
    if geraProduct.basicUnit
      buildInProductUnit =
        creator       : Session.get('myProfile').user
        productCode   : Helpers.randomBarcode()
        buildInProduct: geraProduct._id

      buildInProductUnit._id = Schema.buildInProductUnits.insert buildInProductUnit
      Session.set("geraProductManagementUnitEditingRowId", buildInProductUnit._id )

  scope.updateGeraProductUnit = (buildInProductUnit, template)->
    #TODO: Chinh lai truong hop bi trung randomBarcode()
    unit                  = template.ui.$unit.val()
    barcode               = template.ui.$barcode.val()
    conversionQualityText = template.ui.$conversionQuality.inputmask('unmaskedvalue')
    #    priceText             = template.ui.$price.inputmask('unmaskedvalue')
    #    importPriceText       = template.ui.$importPrice.inputmask('unmaskedvalue')
    #    price       = Math.abs(Helpers.Number(priceText))
    #    importPrice = Math.abs(Helpers.Number(importPriceText))

    conversionQuality = Math.abs(Helpers.Number(conversionQualityText))
    conversionQuality = 1 if conversionQuality < 1

    unitOption =
      unit        : unit
      productCode : barcode
#      price       : price
#      importPrice : importPrice
    unitOption.conversionQuality = conversionQuality if conversionQuality
    Schema.buildInProductUnits.update buildInProductUnit._id, $set: unitOption

