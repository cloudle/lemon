lemon.dependencies.add 'userInfo', ['myOption', 'myProfile', 'mySession']
lemon.dependencies.add 'essentials', ['systems', 'userInfo']

lemon.dependencies.add 'merchantMessenger', ['messengerContacts', 'unreadMessages']
lemon.dependencies.add 'merchantNotification', ['unreadNotifications']
lemon.dependencies.add 'merchantEssential', ['essentials', 'merchantMessenger', 'merchantNotification']

lemon.dependencies.add 'merchantHome', ['merchantEssential', 'myMetroSummaries']