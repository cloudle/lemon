Apps.Gera.geraProductGroupInit.push (scope) ->
  scope.createGeraProductGroup = (template)->
    if fullText = Session.get("geraProductGroupSearchFilter")
      productGroup =
        parentMerchant: Session.get('myProfile').parentMerchant
        creator       : Session.get('myProfile').user
        name          : fullText
        buildIn       : true
        styles        : Helpers.RandomColor()

      existedQuery = {name: fullText, buildIn: true}
      if Schema.productGroups.findOne(existedQuery)
        template.ui.$searchFilter.notify("Nhóm sản phẩm đã tồn tại.", {position: "bottom"})
      else
        productGroup._id = Schema.productGroups.insert productGroup, (error, result) -> console.log error if error
        UserSession.set('geraProductGroupCurrentProductGroup', productGroup._id)
        Session.set("geraProductGroupSearchFilter", "")
        Session.set('geraProductGroupCurrentProductGroup', productGroup)
        template.ui.$searchFilter.val('')

  scope.checkAndUpdateGeraProductGroup = (event, template)->
    if event.which is 27
      if $(event.currentTarget).attr('name') is 'productName'
        $(event.currentTarget).val(Session.get("geraProductGroupCurrentProductGroup").name)
        $(event.currentTarget).change()
      else if $(event.currentTarget).attr('name') is 'description'
        $(event.currentTarget).val(Session.get("geraProductGroupCurrentProductGroup").description)
    else if event.which is 13
      scope.updateGeraProductGroup(template)

  scope.updateGeraProductGroup = (template) ->
    if geraProduct = Session.get("geraProductGroupCurrentProductGroup")
      newName = template.ui.$productName.val()
      newDescription = template.ui.$description.val()

      editOptions = {name: newName, description: newDescription}
      productGroupFound = Schema.productGroups.findOne {name: editOptions.name} if newName.length > 0

      if newName.length is 0
        template.ui.$productName.notify("Tên nhóm sản phẩn không thể để trống.", {position: "right"})
      else if productGroupFound and productGroupFound._id isnt geraProduct._id
        template.ui.$productName.notify("Tên nhóm sản phẩm đã tồn tại.", {position: "right"})
      else
        Schema.productGroups.update geraProduct._id, {$set: editOptions}, (error, result) -> if error then console.log error

        template.ui.$productName.val editOptions.name
        Session.set("geraProductGroupShowEditCommand", false)

  scope.deleteGeraProductGroup = (geraProductGroup) ->
    if geraProductGroup.allowDelete
      Schema.productGroups.remove geraProductGroup._id
      currentGeraProductGroup = Schema.productGroups.findOne({buildIn: true})?._id ? ''
      UserSession.set 'geraProductGroupCurrentProductGroup', currentGeraProductGroup