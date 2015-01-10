lemon.defineApp Template.salesNavigationPartial,
  events:
    "click .saleToCustomer": (event, template) -> Router.go('/customerManagement') if Meteor.userId()
    "click .saleToProduct": (event, template) -> Router.go('/productManagement') if Meteor.userId()
    "click .saleToReturn": (event, template) -> Router.go('/customerReturn') if Meteor.userId()

