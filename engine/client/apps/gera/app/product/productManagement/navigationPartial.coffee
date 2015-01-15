lemon.defineApp Template.geraProductNavigationPartial,
  events:
    "click .productToProductGroup": (event, template) -> Router.go('/geraProductGroup') if Meteor.userId()


