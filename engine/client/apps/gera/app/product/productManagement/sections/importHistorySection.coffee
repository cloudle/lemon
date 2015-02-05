scope = logics.geraProductManagement

lemon.defineHyper Template.geraProductManagementMerchantSection,
  merchantRegisterLists: -> Session.get 'geraProductManagementMerchantList'
  events:
    "click .basicDetailModeDisable": ->
      if product = Session.get(scope.agencyProductManagementCurrentProduct)
        if product.basicDetailModeEnabled is true
          Meteor.call 'updateProductBasicDetailMode', product._id, (error, result) ->
            Meteor.subscribe('agencyProductManagementData', product._id)
          Session.set(scope.agencyProductManagementDetailEditingRow)
          Session.set(scope.agencyProductManagementDetailEditingRowId)
          Session.set(scope.agencyProductManagementUnitEditingRow)
          Session.set(scope.agencyProductManagementUnitEditingRowId)