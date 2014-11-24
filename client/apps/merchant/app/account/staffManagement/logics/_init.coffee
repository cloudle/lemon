logics.staffManagement = {}
Apps.Merchant.staffManagementInit = []
Apps.Merchant.staffManagementReactive = []

Apps.Merchant.staffManagementReactive.push (scope) ->
  if Session.get('allowCreateStaffAccount') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreateStaff = allowCreate