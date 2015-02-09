Schema.add 'roles', "Role", class Role
  @addRolesFor: (profileId, roles) ->
    Schema.userProfiles.update profileId, {$set: {roles: roles}}

  @isInRole: (profileId, name) ->
    currentProfile = Schema.userProfiles.findOne profileId
    return currentProfile isnt undefined && _.contains(currentProfile.roles, name)

  @rolesOf: (permissions)->
    roles = []
    for role in @schema.find({permissions: {$elemMatch: {$in:[permissions, Apps.Merchant.Permissions.su.key]}}}).fetch()
      roles.push role._id
    roles

  @permissionsOf: (profile) ->
    if typeof profile isnt 'string'
      currentProfile = profile
    else
      currentProfile = Schema.userProfiles.findOne profile
      return [] if !currentProfile

    permissions = []
    for role in currentProfile.roles
      currentRole = @schema.findOne(role)
      permissions = _.union permissions, currentRole.permissions if currentRole
    permissions

  @hasPermission: (profileId, name) ->
    currentProfile = Schema.userProfiles.findOne profileId
    return [] if !currentProfile

    permissions = @permissionsOf currentProfile
    return _.contains(permissions, 'su') || _.contains(permissions, name)

  @hasPermissionGroup: (profileId, name, groupName) ->
    currentProfile = Schema.userProfiles.findOne profileId
    return [] if !currentProfile

    groupPermissions = []
    switch groupName
      when "product"
        switch name
          when 'productStaff'
            groupPermissions = ['productSeniorManager', 'productManager', 'productStaff']
          when 'productManager'
            groupPermissions = ['productSeniorManager', 'productManager']
          when 'productSeniorManager'
            groupPermissions = ['productSeniorManager']
      when "customer"
        switch name
          when 'customerStaff'
            groupPermissions = ['customerSeniorManager', 'customerManager', 'customerStaff']
          when 'customerManager'
            groupPermissions = ['customerSeniorManager', 'customerManager']
          when 'customerSeniorManager'
            groupPermissions = ['customerSeniorManager']
      when "distributor"
        switch name
          when 'distributorStaff'
            groupPermissions = ['distributorSeniorManager', 'distributorManager', 'distributorStaff']
          when 'distributorManager'
            groupPermissions = ['distributorSeniorManager', 'distributorManager']
          when 'distributorSeniorManager'
            groupPermissions = ['distributorSeniorManager']
      when "sales"
        switch name
          when 'saleStaff'
            groupPermissions = ['saleManager', 'saleStaff']
          when 'saleDebt'
            groupPermissions = ['saleManager', 'saleDebt']
          when 'saleDelivery'
            groupPermissions = ['saleManager', 'saleDelivery']
          when 'saleOrder'
            groupPermissions = ['saleManager', 'saleOrder']
          when 'saleManager'
            groupPermissions = ['saleManager',]
      when "delivery"
        switch name
          when 'saleStaff'
            groupPermissions = ['deliveryManager', 'saleStaff']
          when 'deliveryManager'
            groupPermissions = ['deliveryManager']
      when "customerReturn"
        switch name
          when 'customerReturnStaff'
            groupPermissions = ['customerReturnManager', 'customerReturnStaff']
          when 'customerReturnManager'
            groupPermissions = ['customerReturnManager']
      when "distributorReturn"
        switch name
          when 'distributorReturnManager'
            groupPermissions = ['distributorReturnManager']
      when "warehouse"
        switch name
          when 'warehouseStaff'
            groupPermissions = ['warehouseSeniorManager', 'warehouseManager', 'transactionStaff']
          when 'warehouseManager'
            groupPermissions = ['warehouseSeniorManager', 'warehouseManager']
          when 'warehouseSeniorManager'
            groupPermissions = ['warehouseSeniorManager']
      when "transaction"
        switch name
          when 'transactionStaff'
            groupPermissions = ['transactionSeniorManager', 'transactionManager', 'transactionStaff']
          when 'transactionManager'
            groupPermissions = ['transactionSeniorManager', 'transactionManager']
          when 'transactionSeniorManager'
            groupPermissions = ['transactionSeniorManager']

    permissions = @permissionsOf currentProfile
    return true if _.contains(permissions, 'su')
    for permission in groupPermissions
      if _.contains(permissions, permission) then return true
    return false