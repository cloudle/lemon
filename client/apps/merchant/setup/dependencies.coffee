lemon.dependencies.add 'userInfo', ['myOption', 'myProfile', 'mySession']
lemon.dependencies.add 'essentials', ['systems', 'userInfo']

lemon.dependencies.add 'merchantMessenger', ['myMerchantContacts', 'unreadMessages']
lemon.dependencies.add 'merchantNotification', ['unreadNotifications']
lemon.dependencies.add 'merchantEssential', ['essentials', 'merchantMessenger', 'merchantNotification']

lemon.dependencies.add 'merchantHome', ['merchantEssential', 'myMetroSummaries']
lemon.dependencies.add 'roleManager', ['merchantEssential', 'currentMerchantRoles']
lemon.dependencies.add 'staffManager', ['merchantEssential', 'currentMerchantRoles']

lemon.dependencies.add 'saleOrder', ['merchantEssential',
                                     'myOrderHistoryAndDetail',
                                     'mySaleAndDetail',
                                     'products',
                                     'skulls',
                                     'providers',
                                     'customers']

lemon.dependencies.add 'warehouseImport', ['merchantEssential',
                                           'myImportHistoryAndDetail',
                                           'products',
                                           'productDetails',
                                           'skulls',
                                           'providers']