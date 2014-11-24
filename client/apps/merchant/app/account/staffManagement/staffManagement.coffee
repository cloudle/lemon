scope = logics.staffManagement

lemon.defineApp Template.staffManagement,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentStaff: -> Session.get("staffManagementCurrentStaff")
  activeClass:-> if Session.get("staffManagementCurrentStaff")?._id is @._id then 'active' else ''
#  rendered: -> $(".nano").nanoScroller()
  events:
    "click .inner.caption": (event, template) -> Session.set("staffManagementCurrentStaff", @)
    "input input": (event, template) -> scope.checkAllowCreateStaff(template)
    'click .create-staff': (event, template)-> scope.createStaff(template)