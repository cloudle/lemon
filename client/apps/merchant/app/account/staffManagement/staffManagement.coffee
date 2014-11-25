scope = logics.staffManagement

lemon.defineApp Template.staffManagement,
  showFilterSearch: -> Session.get("staffManagementSearchFilter").length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentStaff: -> Session.get("staffManagementCurrentStaff")
  activeClass:-> if Session.get("staffManagementCurrentStaff")?._id is @._id then 'active' else ''
#  rendered: -> $(".nano").nanoScroller()
  events:
    "input .search-filter": (event, template) -> Session.set("staffManagementSearchFilter", template.ui.$searchFilter.val())
    "click .inner.caption": (event, template) -> Session.set("staffManagementCurrentStaff", @)
    "input input": (event, template) -> scope.checkAllowCreateStaff(template)
    'click .create-staff': (event, template)-> scope.createStaff(template)