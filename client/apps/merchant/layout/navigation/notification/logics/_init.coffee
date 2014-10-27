notification = logics.merchantNotification = {}

sentByMe = {sender: Meteor.userId()}
sendToMe = {receiver: Meteor.userId()}
unread   = {reads: {$ne: Meteor.userId()}}

notification.notifies = Schema.notifications.find({ isRequest: false })
notification.unreadNotifies = Schema.notifications.find({ isRequest: false, seen: false })

notification.requests = Schema.notifications.find { isRequest: true }, {sort: {'version.createdAt': -1}}
notification.unreadRequests = Schema.notifications.find { isRequest: true, seen: false }

notification.topMessages = Schema.messages.find { $or: [sentByMe, sendToMe] }, {sort: {'version.createdAt': -1}, limit: 10}
notification.unreadMessages = Schema.messages.find { $and: [sendToMe, unread] }