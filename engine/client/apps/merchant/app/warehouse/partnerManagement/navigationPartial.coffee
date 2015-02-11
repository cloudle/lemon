lemon.defineApp Template.partnerManagementNavigationPartial,
  events:
    "click .partnerToImport": (event, template) ->
      if partner = Session.get("partnerManagementCurrentPartner")
        Meteor.call 'partnerToImport', partner, Session.get('myProfile'), (error, result) ->
          if error then console.log error else Router.go('/import')