logics.agencyProductManagement = {}
Apps.Agency.agencyProductManagementInit = []
Apps.Agency.agencyProductManagementReactive = []

Apps.Agency.agencyProductManagementInit.push (scope) ->
  scope.agencyProductManagementBranchProduct       = "agencyProductManagementBranchProductSummary"
  scope.agencyProductManagementBuildInProduct      = "agencyProductManagementBuildInProduct"

  scope.agencyProductManagementCurrentProduct      = "agencyProductManagementCurrentProduct"
  scope.agencyProductManagementCurrentProductId    = "currentAgencyProductManagementSelection"

  scope.agencyProductManagementUnitEditingRow      = "agencyProductManagementUnitEditingRow"
  scope.agencyProductManagementUnitEditingRowId    = "agencyProductManagementUnitEditingRowId"

  scope.agencyProductManagementDetailEditingRow    = "agencyProductManagementDetailEditingRow"
  scope.agencyProductManagementDetailEditingRowId  = "agencyProductManagementDetailEditingRowId"

  scope.agencyProductManagementProductSearchFilter = "agencyProductManagementSearchFilter"
  scope.agencyProductManagementProductEditCommand  = "agencyProductManagementShowEditCommand"

  scope.agencyProductManagementProductCreationMode = "agencyProductManagementCreationMode"


