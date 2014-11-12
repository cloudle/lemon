lemon.dependencies.add 'userInfo', ['myOption', 'myProfile', 'mySession']
lemon.dependencies.add 'essentials', ['userInfo', 'myPurchase']

lemon.dependencies.add 'home', ['essentials']
lemon.dependencies.add 'merchantPurchase', ['essentials']

#lemon.dependencies.add 'merchantInfo', ['myMerchant', 'myWarehouse']

lemon.dependencies.add 'merchantMessenger', ['myMerchantProfiles', 'unreadMessages']
lemon.dependencies.add 'merchantNotification', ['unreadNotifications']
lemon.dependencies.add 'merchantEssential', ['essentials', 'merchantMessenger', 'merchantNotification', 'myMerchantAndWarehouse', 'myMetroSummaries']

lemon.dependencies.add 'merchantHome', ['merchantEssential']
lemon.dependencies.add 'roleManager', ['merchantEssential', 'currentMerchantRoles']
lemon.dependencies.add 'staffManager', ['merchantEssential', 'myMerchantProfiles', 'currentMerchantRoles', 'availableBranch', 'allWarehouse']
lemon.dependencies.add 'customerManager', ['merchantEssential', 'availableCustomers']
lemon.dependencies.add 'transactionManager', ['merchantEssential', 'receivableAndRelates']

lemon.dependencies.add 'accountingManager', ['merchantEssential', 'saleBillAccounting']
lemon.dependencies.add 'billManager', ['merchantEssential', 'billManagerSales']
lemon.dependencies.add 'deliveryManager', ['merchantEssential', 'availableDeliveries']
lemon.dependencies.add 'returnManager', ['merchantEssential', 'availableSales']

lemon.dependencies.add 'salesReport', ['merchantEssential', 'saleBills']
lemon.dependencies.add 'saleOrder', ['merchantEssential',
                                     'myOrderHistory',
                                     'mySaleAndDetail',
                                     'products',
                                     'skulls',
                                     'providers',
                                     'availableCustomers']


lemon.dependencies.add 'branchManager', ['merchantEssential', 'availableBranch']
lemon.dependencies.add 'warehouseManager', ['merchantEssential', 'availableWarehouse']
lemon.dependencies.add 'stockManager', ['merchantEssential', 'allProducts']
lemon.dependencies.add 'importHistory', ['merchantEssential', 'importHistoryInWarehouse', 'availableBranch', 'allWarehouse']
lemon.dependencies.add 'warehouseImport', ['merchantEssential',
                                           'myImportHistory',
                                           'allProducts',
                                           'skulls',
                                           'providers']


lemon.dependencies.add 'inventoryHistory', ['merchantEssential', 'allInventory']
lemon.dependencies.add 'inventoryManager', ['merchantEssential', 'allInventoryAndDetail', 'availableBranch', 'allWarehouse']

lemon.dependencies.add 'transportHistory', ['merchantEssential', 'allInventoryAndDetail', 'availableBranch', 'allWarehouse']
