scope = logics.customerManagement

lemon.defineApp Template.customerManagement,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  activeClass:-> if Session.get("customerManagementCurrentCustomer")?._id is @._id then 'active' else ''
#  rendered: -> $(".nano").nanoScroller()
  events:
    "click .inner.caption": (event, template) -> Session.set("customerManagementCurrentCustomer", @)