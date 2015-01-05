Apps.Merchant.notificationTypes =
  notify:                   { key: 'notify' }
  request:                  { key: 'request' }
  event:                    { key: 'event' }

Apps.Merchant.notificationCharacteristics =
  event:                    {key: 'event'}
  alert:                    {key: 'alert'}
  danger:                   {key: 'danger'}

Apps.Merchant.notificationGroup =
  expireDate:               {key: 'expireDate'}
  receivableDate:           {key: 'receivableDate'}
  payableDate:              {key: 'payableDate'}
  alertQuality:             {key: 'alertQuality'}


Apps.Merchant.NotificationMessages = {}

Apps.Merchant.NotificationMessages.permissionChanged = (creator) -> "#{creator} đã điều chỉnh phân quyền lại cho bạn!"
Apps.Merchant.NotificationMessages.newMemberJoined   = (userName, companyName) -> "Chào mừng #{userName} đã gia nhập #{companyName}!"
Apps.Merchant.NotificationMessages.placeChanged      = (creator, place) -> "#{userName} đã chuyển bạn tới #{place}!" #Kho, Chi Nhánh

Apps.Merchant.NotificationMessages.managerReturnConfirm = (creator, value) -> "Có một đơn trả hàng #{value} cần duyệt" #Manager, Warehouse, Accounting
Apps.Merchant.NotificationMessages.saleHelper       = (creator, orderCode, value) -> "#{creator} đã bán dùm bạn một đơn hàng #{orderCode} có giá trị #{value}"

Apps.Merchant.NotificationMessages.productExpireDate   = (productName, date, place)    ->
  if date > 0
    "Sản phẩm #{productName}, tại kho #{place} sắp hết hạn (còn #{date} ngày)."
  else
    "Sản phẩm #{productName}, tại kho #{place} đã hết hạn #{-date} ngày trước."

Apps.Merchant.NotificationMessages.receivableExpireDate= (customerName, date, place)   -> "Khách hàng #{customerName} đã trể quá han trả tiền #{date} ngày."
Apps.Merchant.NotificationMessages.payableExpireDate   = (companyName, date, place)    -> "C.Ty đã quá hạn trả tiền C.ty #{companyName} #{date} ngày."
Apps.Merchant.NotificationMessages.productAlertQuality = (productName, quality, place) -> "Sản phẩm #{productName}, tại kho #{place} sắp hết hàng (còn #{quality} sản phẩm)."

Apps.Merchant.NotificationMessages.sendAccountingByNewSale  = (creator, orderCode, place)    -> "Có một đơn hàng mới #{orderCode} của #{creator}, cần bạn xác nhận đã thu tiền"
Apps.Merchant.NotificationMessages.sendExporterBySaleExport = (creator, orderCode, place)    -> "Có một đơn hàng mới #{orderCode} của #{creator}, cần bạn xác nhận đã xuất kho"
Apps.Merchant.NotificationMessages.sendShipperByNewDelivery = (creator, orderCode, place)    -> "Có một đơn hàng mới #{orderCode} của #{creator}, tại #{place} đang chờ giao"
Apps.Merchant.NotificationMessages.sendShipperByExport      = (exportName, orderCode, place) -> "Đơn giao hàng #{orderCode} của bạn đã nhận, đã được xác nhận xuất kho bởi #{exportName}"

Apps.Merchant.NotificationMessages.sendNewReturnCreate        = (creator, returnCode, place) -> "Có một đơn trả hàng mới #{returnCode} của #{creator}, tại #{place} đang chờ xác nhận của bạn."
Apps.Merchant.NotificationMessages.sendCreatorByReturnConfirm = (creator, returnCode, place) -> "Đơn trả hàng #{returnCode} của bạn, tại #{place} đã đươc xác nhận bởi #{creator}."
Apps.Merchant.NotificationMessages.sendCreatorByReturnDestroy = (creator, returnCode, place) -> "Đơn trả hàng #{returnCode} của bạn, tại #{place} đã bị hủy bởi #{creator}."

Apps.Merchant.NotificationMessages.sendNewInventoryCreate        = (creator, returnCode, place) -> "Có một đơn kiểm kho mới #{returnCode} của #{creator}, tại #{place} đang chờ xác nhận của bạn."
Apps.Merchant.NotificationMessages.sendCreatorByInventoryConfirm = (creator, returnCode, place) -> "Đơn kiểm kho #{returnCode} của bạn, tại #{place} đã đươc xác nhận bởi #{creator}."
Apps.Merchant.NotificationMessages.sendCreatorByInventoryDestroy = (creator, returnCode, place) -> "Đơn kiểm kho #{returnCode} của bạn, tại #{place} đã bị hủy bởi #{creator}."


Apps.Merchant.NotificationMessages.sendByCashier                    = (cashier, orderCode)           -> "Đơn bán hàng #{orderCode} của bạn, đã được xác nhận thu tiền bởi #{cashier}"
Apps.Merchant.NotificationMessages.sendCreatorSaleByCashier         = (cashier, seller, orderCode)   -> "Đơn bán hàng #{orderCode} được bạn tạo dùm cho #{seller}, đã được xác nhận thu tiền bởi #{cashier}"
Apps.Merchant.NotificationMessages.sendSellerSaleByCashier          = (cashier, cretator, orderCode) -> "Đơn bán hàng #{orderCode} được tạo dùm bởi #{cretator}, đã được xác nhận thu tiền bởi #{cashier}"

Apps.Merchant.NotificationMessages.sendByExporter                   = (exporter, orderCode)          -> "Đơn bán hàng #{orderCode} của bạn, đã được xác nhận xuất kho bởi #{exporter}"
Apps.Merchant.NotificationMessages.sendCreatorSaleByExporter        = (exporter, seller, orderCode)  -> "Đơn bán hàng #{orderCode} được bạn tạo dùm cho #{seller}, đã được xác nhận xuất kho bởi #{exporter}"
Apps.Merchant.NotificationMessages.sendSellerSaleByExporter         = (exporter, cretator, orderCode)-> "Đơn bán hàng #{orderCode} được tạo dùm bởi #{cretator}, đã được xác nhận xuất kho bởi #{exporter}"

Apps.Merchant.NotificationMessages.sendByImporter                   = (importer, orderCode)          -> "Đơn bán hàng #{orderCode} của bạn, đã được xác nhận nhập kho bởi #{importer}"
Apps.Merchant.NotificationMessages.sendCreatorSaleByImporter        = (importer, seller, orderCode)  -> "Đơn bán hàng #{orderCode} được bạn tạo dùm cho #{seller}, đã được xác nhận nhập kho bởi #{importer}"
Apps.Merchant.NotificationMessages.sendSellerSaleByImporter         = (importer, cretator, orderCode)-> "Đơn bán hàng #{orderCode} được tạo dùm bởi #{cretator}, đã được xác nhận nhập kho bởi #{importer}"

Apps.Merchant.NotificationMessages.sendByShipperSelected            = (shipper, orderCode)           -> "Đơn bán hàng #{orderCode} của bạn, đã được nhận giao bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendCreatorSaleByShipperSelected = (shipper, seller, orderCode)   -> "Đơn bán hàng #{orderCode} được bạn tạo dùm cho #{seller}, đã được nhận giao bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendSellerSaleByShipperSelected  = (shipper, cretator, orderCode) -> "Đơn bán hàng #{orderCode} được tạo dùm bởi #{cretator}, đã được nhận giao bởi #{shipper}"

Apps.Merchant.NotificationMessages.sendByShipperWorking             = (shipper, orderCode)           -> "Đơn bán hàng #{orderCode} của bạn, đã bắt đầu đi giao bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendCreatorSaleByShipperWorking  = (shipper, seller, orderCode)   -> "Đơn bán hàng #{orderCode} được bạn tạo dùm cho #{seller}, đã bắt đầu đi giao bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendSellerSaleByShipperWorking   = (shipper, cretator, orderCode) -> "Đơn bán hàng #{orderCode} được tạo dùm bởi #{cretator}, đã bắt đầu đi giao bởi #{shipper}"

Apps.Merchant.NotificationMessages.sendByDeliverySuccess            = (shipper, orderCode)           -> "Đơn bán hàng #{orderCode} của bạn, đã giao hàng thành công bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendCreatorSaleByDeliverySuccess = (shipper, seller, orderCode)   -> "Đơn bán hàng #{orderCode} được bạn tạo dùm cho #{seller}, đã giao hàng thành công bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendSellerSaleByDeliverySuccess  = (shipper, cretator, orderCode) -> "Đơn bán hàng #{orderCode} được tạo dùm bởi #{cretator}, đã giao hàng thành công bởi #{shipper}"

Apps.Merchant.NotificationMessages.sendByDeliveryFail               = (shipper, orderCode)           -> "Đơn bán hàng #{orderCode} của bạn, đã giao hàng thất bại bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendCreatorSaleByDeliveryFail    = (shipper, seller, orderCode)   -> "Đơn bán hàng #{orderCode} được bạn tạo dùm cho #{seller}, đã giao hàng thất bại bởi #{shipper}"
Apps.Merchant.NotificationMessages.sendSellerSaleByDeliveryFail     = (shipper, cretator, orderCode) -> "Đơn bán hàng #{orderCode} được tạo dùm bởi #{cretator}, đã giao hàng thất bại bởi #{shipper}"
