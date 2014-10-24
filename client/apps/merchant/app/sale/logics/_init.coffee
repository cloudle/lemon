logics.sales = {}
logics.sales.currentOrder = Schema.orders.find({user: Meteor.userId()})