lemon.defineApp Template.geraProductGroupNavigationPartial,
  events:
    "click .productGroupToProduct": (event, template) -> Router.go('/geraProductManagement') if Meteor.userId()

