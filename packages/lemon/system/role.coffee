Schema.add 'roles', "Role", class Role
  @addRolesFor: (profileId, roles) ->
    Schema.userProfiles.update profileId, {$set: {roles: roles}}

  @isInRole: (profileId, name) ->
    currentProfile = Schema.userProfiles.findOne profileId
    return currentProfile isnt undefined && _.contains(currentProfile.roles, name)

  @rolesOf: (permissions)->
    roles = []
    for role in @schema.find({permissions: {$elemMatch: {$in:[permissions, Apps.Merchant.Permissions.su.key]}}}).fetch()
      roles.push role.name
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
    return _.contains(currentProfile.roles, 'admin') || _.contains(permissions, name)