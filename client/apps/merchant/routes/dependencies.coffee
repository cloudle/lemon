lemon.dependencies.add 'userInfo', ['myOption', 'myProfile', 'mySession']
lemon.dependencies.add 'essentials', ['systems', 'userInfo']

lemon.dependencies.add 'customerInfo', ['customers']
lemon.dependencies.add 'productInWarehouseInfo', ['productSale' ,'skulls', 'providers']
lemon.dependencies.add 'productDetailInWarehouse', ['productDetails', 'skulls', 'providers']

lemon.dependencies.add 'merchantMessenger', ['currentMerchantContacts', 'unreadMessages']
lemon.dependencies.add 'merchantNotification', ['unreadNotifications']
lemon.dependencies.add 'merchantEssential', ['essentials', 'merchantMessenger', 'merchantNotification']

lemon.dependencies.add 'merchantHome', ['merchantEssential', 'myMetroSummaries']
lemon.dependencies.add 'roleManager', ['merchantEssential', 'currentMerchantRoles']
lemon.dependencies.add 'staffManager', ['merchantEssential', 'currentMerchantRoles']

lemon.dependencies.add 'saleOrder', ['merchantEssential', 'myOrderHistoryAndDetail', 'mySaleAndDetail', 'productInWarehouseInfo']
lemon.dependencies.add 'warehouseImport', ['merchantEssential']