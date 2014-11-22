scope = logics.customerManagement

lemon.defineApp Template.customerManagement,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  events:
    "click .inner.caption": (event, template) -> Session.set("customerManagementCurrentCustomer", @)