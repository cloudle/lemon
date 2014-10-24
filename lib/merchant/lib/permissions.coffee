Apps.Merchant.Permissions =
  su                    : { group: 'special'   , key: 'su'                 , description: 'tất cả' }
  sales                 : { group: 'sales'     , key: 'sales'              , description: 'bán hàng' }
  returns               : { group: 'sales'     , key: 'returns'            , description: 'trả hàng' }
  detroySalesBill       : { group: 'sales'     , key: 'destroySalesBill'   , description: 'xóa hóa đơn' }
  delivery              : { group: 'sales'     , key: 'delivery'           , description: 'giao hàng' }
  deliveryConfirm       : { group: 'sales'     , key: 'deliveryConfirm'    , description: 'xác nhận giao hàng' }
  deliveryDestroy       : { group: 'sales'     , key: 'deliveryDestroy'    , description: 'hủy giao hàng' }
  exportDelivery        : { group: 'sales'     , key: 'exportDelivery'     , description: 'xác nhận xuất kho giao hàng' }
  importDestroy         : { group: 'sales'     , key: 'deliveryDestroy'    , description: 'xác nhận nhập kho giao hàng' }
  cashDestroy           : { group: 'sales'     , key: 'importDestroy'      , description: 'xác nhận thu tiền giap hàng' }

  saleCashier           : { group: 'accounting', key: 'saleCashier'        , description: 'xác nhận thu tiền khi bán hàng' }
  deliveryCashier       : { group: 'accounting', key: 'deliveryCashier'    , description: 'xác nhận thu tiền khi giao hàng' }

  saleExporter          : { group: 'warehouse' , key: 'saleExporter'       , description: 'xuất kho khi bán hàng' }
  deliveryExporter      : { group: 'warehouse' , key: 'deliveryExporter'   , description: 'nhập kho khi giao hàng thất bại' }

  export                : { group: 'warehouse' , key: 'export'             , description: 'xuất kho' }
  exportDestroy         : { group: 'warehouse' , key: 'exportDestroy'      , description: 'hủy xuất kho' }
  import                : { group: 'warehouse' , key: 'import'             , description: 'nhập kho' }
  importDestroy         : { group: 'warehouse' , key: 'importDestroy'      , description: 'hủy nhập kho' }
  destroyImport         : { group: 'warehouse' , key: 'destroyImport'      , description: 'xóa phiếu nhập kho' }


  shipper               : { group: 'delivery'  , key: 'shipper'            , description: 'giao hàng' }

  accountManagement     : { group: 'human'     , key: 'accountManagement'  , description: 'quản lý nhân viên' }

  createCustomer        : { group: 'crm'       , key: 'createCustomer'     , description: 'tạo khách hàng' }
  customerShow          : { group: 'crm'       , key: 'customerShow'       , description: 'quản lý khách hàng' }
  customerManagement    : { group: 'crm'       , key: 'customerManagement' , description: 'quản lý khách hàng' }

  transactionShow       : { group: 'finance'   , key: 'transactionShow'    , description: 'xem thu chi' }
  transactionManagement : { group: 'finance'   , key: 'transactionShow'    , description: 'q.lý thu chi' }

  taskShow              : { group: 'scrum'     , key: 'scrumShow'          , description: 'xem task' }
  createTask            : { group: 'scrum'     , key: 'scrumShow'          , description: 'tạo task' }
  taskManagement        : { group: 'scrum'     , key: 'scrumShow'          , description: 'q.lý task' }