scope = logics.distributorManagement

lemon.defineWidget Template.distributorManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined