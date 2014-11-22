scope = logics.customerManagement

lemon.defineWidget Template.customerManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined