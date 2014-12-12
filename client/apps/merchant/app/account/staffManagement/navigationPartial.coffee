lemon.defineApp Template.staffManagementNavigationPartial,
  events:
    "click .staffToSales": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        Meteor.call 'staffToSales', staff, Session.get('myProfile'), (error, result) ->
          if error then console.log error else Router.go('/sales')
