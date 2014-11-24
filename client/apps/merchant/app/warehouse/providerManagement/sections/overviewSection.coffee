scope = logics.providerManagement

lemon.defineWidget Template.providerManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined