scope = logics.staffManagement

lemon.defineWidget Template.staffManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined