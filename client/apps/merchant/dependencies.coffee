lemon.dependencies.add 'userInfo', ['myOption', 'myProfile', 'mySession']
lemon.dependencies.add 'essentials', ['systems', 'userInfo']

#lemon.dependencies.add 'merchantInfo', ['myMerchant', 'myWarehouse']

lemon.dependencies.add 'merchantMessenger', ['myMerchantProfiles', 'unreadMessages']
lemon.dependencies.add 'merchantNotification', ['unreadNotifications']
lemon.dependencies.add 'merchantEssential', ['essentials', 'merchantMessenger', 'merchantNotification', 'myMerchantAndWarehouse']

lemon.dependencies.add 'merchantHome', ['merchantEssential', 'myMetroSummaries']
lemon.dependencies.add 'roleManager', ['merchantEssential', 'currentMerchantRoles']
lemon.dependencies.add 'staffManager', ['merchantEssential', 'myMerchantProfiles', 'currentMerchantRoles', 'availableBranch', 'availableWarehouse']
lemon.dependencies.add 'customerManager', ['merchantEssential', 'availableCustomers']
lemon.dependencies.add 'salesReport', ['merchantEssential', 'saleBills']

lemon.dependencies.add 'saleOrder', ['merchantEssential',
                                     'myOrderHistory',
                                     'mySaleAndDetail',
                                     'products',
                                     'skulls',
                                     'providers',
                                     'availableCustomers']

lemon.dependencies.add 'warehouseImport', ['merchantEssential',
                                           'myImportHistory',
                                           'allProducts',
                                           'skulls',
                                           'providers']

lemon.dependencies.add 'accountingManager', ['merchantEssential', 'saleBillAccounting']
lemon.dependencies.add 'billManager', ['merchantEssential', 'billManagerSales']
lemon.dependencies.add 'deliveryManager', ['merchantEssential', 'availableDeliveries']
lemon.dependencies.add 'returnManager', ['merchantEssential', 'availableSales']
lemon.dependencies.add 'warehouseManager', ['merchantEssential', 'availableWarehouse']
lemon.dependencies.add 'branchManager', ['merchantEssential', 'availableBranch']
lemon.dependencies.add 'transactionManager', ['merchantEssential', 'receivableAndRelates']
lemon.dependencies.add 'stockManager', ['merchantEssential', 'allProducts']

lemon.dependencies.add 'inventoryReview', ['merchantEssential', 'allInventory']
lemon.dependencies.add 'inventoryHistory', ['merchantEssential', 'allInventory']


lemon.dependencies.add 'inventoryManager', ['merchantEssential',
                                            'availableBranch',
                                            'allWarehouse',
                                            'allInventoryAndDetail',
                                            'products',
                                            'allProductDetails']