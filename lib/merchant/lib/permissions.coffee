Apps.Merchant.Permissions =
  su                    :{group: 'special'     ,key:'su'                   ,description: 'tất cả' }
  permissionManagement  :{group: 'account'     ,key:'permissionManagement' ,description: 'thay đổi phân quyền' }

  sales                 :{group: 'sales'       ,key:'sales'                ,description: 'bán hàng'     }
  destroySalesBill      :{group: 'sales'       ,key:'destroySalesBill'     ,description: 'xóa hóa đơn' }
  returnCreate          :{group: 'returns'    ,key:'returnCreate'          ,description: 'tạo phiếu trả hàng' }
  returnShow            :{group: 'returns'    ,key:'returnShow'            ,description: 'xem trả hàng'       }
  returnEdit            :{group: 'returns'    ,key:'returnEdit'            ,description: 'chỉnh trả hàng'     }
  returnConfirm         :{group: 'returns'    ,key:'returnConfirm'         ,description: 'xác nhận trả hàng'  }
  returnDestroy         :{group: 'returns'    ,key:'returnShow'            ,description: 'hủy trả hàng'       }
  destroyReturn         :{group: 'returns'    ,key:'destroyReturn'         ,description: 'xóa trả hàng'       }

  deliveryCreate        :{group: 'delivery'    ,key:'deliveryCreate'       ,description: 'tạo giao hàng'      }
  deliveryShow          :{group: 'delivery'    ,key:'deliveryShow'         ,description: 'xem giao hàng'      }
  deliveryEdit          :{group: 'delivery'    ,key:'deliveryEdit'         ,description: 'chỉnh giao hàng'    }
  deliveryConfirm       :{group: 'delivery'    ,key:'deliveryConfirm'      ,description: 'xác nhận giao hàng' }
  deliveryDestroy       :{group: 'delivery'    ,key:'deliveryDestroy'      ,description: 'hủy giao hàng'      }
  destroyDelivery       :{group: 'delivery'    ,key:'destroyDelivery'      ,description: 'xóa giao hàng'      }

  importShow            :{group: 'import'   ,key:'importShow'           ,description: 'xem nhập kho'     }
  importCreate          :{group: 'import'   ,key:'importCreate'         ,description: 'tạo nhập kho'     }
  importEdit            :{group: 'import'   ,key:'importEdit'           ,description: 'chỉnh nhập kho'   }
  importConfirm         :{group: 'import'   ,key:'importConfirm'        ,description: 'xác nhận nhập kho'}
  importDestroy         :{group: 'import'   ,key:'importDestroy'        ,description: 'hủy nhập kho'     }
  destroyImport         :{group: 'import'   ,key:'destroyImport'        ,description: 'xóa nhập kho'     }

  exportShow            :{group: 'export'   ,key:'exportShow'           ,description: 'xem xuất kho'     }
  exportCreate          :{group: 'export'   ,key:'exportCreate'         ,description: 'tạo xuất kho'     }
  exportEdit            :{group: 'export'   ,key:'exportEdit'           ,description: 'chỉnh xuất kho'   }
  exportConfirm         :{group: 'export'   ,key:'exportConfirm'        ,description: 'xác nhận xuất kho'}
  exportDestroy         :{group: 'export'   ,key:'exportDestroy'        ,description: 'hủy xuất kho'     }
  destroyExport         :{group: 'export'   ,key:'destroyExport'        ,description: 'xóa xuất kho'     }

  inventoryShow         :{group: 'inventory'   ,key:'inventoryShow'        ,description: 'xem kiểm kho'     }
  inventoryCreate       :{group: 'inventory'   ,key:'inventoryCreate'      ,description: 'tạo kiểm kho'     }
  inventoryEdit         :{group: 'inventory'   ,key:'inventoryEdit'        ,description: 'chỉnh kiểm kho'   }
  inventoryConfirm      :{group: 'inventory'   ,key:'inventoryConfirm'     ,description: 'xác nhận kiểm kho'}
  inventoryDestroy      :{group: 'inventory'   ,key:'inventoryDestroy'     ,description: 'hủy kiểm kho'     }
  destroyInventory      :{group: 'inventory'   ,key:'destroyInventory'     ,description: 'xóa kiểm kho'     }

  cashierSale           :{group: 'accounting'  ,key:'cashierSale'          ,description: 'xác nhận thu tiền khi bán hàng' }
  cashierDelivery       :{group: 'accounting'  ,key:'cashierDelivery'      ,description: 'xác nhận thu tiền khi giao hàng thành công' }
  transactionShow       :{group: 'accounting'  ,key:'transactionShow'      ,description: 'xem thu chi' }
  transactionManagement :{group: 'accounting'  ,key:'transactionManagement',description: 'q.lý thu chi' }

  saleExport            :{group: 'warehouse'   ,key:'saleExport'           ,description: 'xuất kho khi bán hàng' }
  importDelivery        :{group: 'warehouse'   ,key:'importDelivery'       ,description: 'xác nhận nhập kho khi giao hàng thất bại' }
  warehouseManagement   :{group: 'warehouse'   ,key:'warehouseManagement'  ,description: 'quản lý kho hàng' }

  accountManagement     :{group: 'human'       ,key:'accountManagement'   ,description: 'quản lý nhân viên' }

  customerCreate        :{group: 'crm'         ,key:'createCustomer'      ,description: 'tạo khách hàng' }
  customerShow          :{group: 'crm'         ,key:'customerShow'        ,description: 'xem khách hàng' }
  customerManagement    :{group: 'crm'         ,key:'customerManagement'  ,description: 'quản lý khách hàng' }


  customerTransaction   :{group: 'transaction' ,key:'customerTransaction'  ,description: 'thêm công nợ cho khách hàng' }


  taskShow              :{group: 'scrum'       ,key:'scrumShow'           ,description: 'xem task' }
  taskCreate            :{group: 'scrum'       ,key:'scrumCreate'         ,description: 'tạo task' }
  taskManagement        :{group: 'scrum'       ,key:'scrumManagement '    ,description: 'q.lý task' }

Apps.Merchant.PermissionGroups =
  sales:
    icon: "icon-basket-1"
    description: "bán hàng"
    children: ['sales', 'destroySalesBill', 'returnCreate', 'returnShow', 'returnEdit', 'returnConfirm', 'returnDestroy', 'destroyReturn']
  delivery:
    icon: "icon-truck-1"
    description: "giao hàng"
    children: ['deliveryCreate', 'deliveryShow', 'deliveryEdit', 'deliveryConfirm', 'deliveryDestroy', 'destroyDelivery']
  import:
    icon: "icon-cubes"
    description: "nhập kho"
    children: ['importShow', 'importCreate', 'importEdit', 'importConfirm', 'importDestroy', 'destroyImport']
  export:
    icon: "icon-paper-plane-empty"
    description: "xuất kho"
    children: ['exportShow', 'exportCreate', 'exportEdit', 'exportConfirm', 'exportDestroy', 'destroyExport']
  inventory:
    icon: "icon-history"
    description: "kiểm kho"
    children: ['inventoryShow', 'inventoryCreate', 'inventoryEdit', 'inventoryConfirm', 'inventoryDestroy', 'destroyInventory']
  accounting:
    icon: "icon-clipboard"
    description: "kế toán"
    children: ['cashierSale', 'cashierDelivery', 'transactionShow', 'transactionManagement']
  staffing:
    icon: "icon-group"
    description: "nhân sự"
    children: ['accountManagement']
  crm:
    icon: "icon-heart-8"
    description: "khách hàng"
    children: ['customerCreate', 'customerShow', 'customerManagement']
  task:
    icon: "icon-clipboard-2"
    description: "công việc"
    children: ['taskShow', 'taskCreate', 'taskManagement']
