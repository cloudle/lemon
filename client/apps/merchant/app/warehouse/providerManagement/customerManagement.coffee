scope = logics.providerManagement

lemon.defineApp Template.providerManagement,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProvider: -> Session.get("providerManagementCurrentProvider")
  activeClass:-> if Session.get("providerManagementCurrentProvider")?._id is @._id then 'active' else ''
#  rendered: -> $(".nano").nanoScroller()
  events:
    "click .inner.caption": (event, template) -> Session.set("providerManagementCurrentProvider", @)