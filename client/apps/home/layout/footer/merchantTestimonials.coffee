comments = [
  name: -> 'Nguyễn Thị Ngọc Tuyền'
  position: -> 'Khu du lịch sinh thái (Tiền Giang)'
  avatar: -> 'c.tuyen.jpg'
  comment: -> "Vào những ngày cuối tuần hay dịp lễ Tết, khách đến tham quan rất nhiều, hệ thống nhắc nhở tự động giúp
               chúng tôi chủ động hơn trong việc chăm sóc khách hàng."
,
  name: -> 'Phan Ngọc Vinh'
  position: -> 'Chủ xưởng gỗ Vinh Phát (Đắc Lắc)'
  avatar: -> 'a.vinh.jpg'
  comment: -> "Tôi đã tìm hiểu qua nhiều phần mềm quản lý trước khi quyết định sử dụng EDS. Đây là phần mềm tiện dụng
               nhất mà tôi từng biết, tôi rất ấn tượng với giao diện metro, rất đẹp và dễ hiểu."
,
  name: -> 'Nguyễn Anh Phương'
  position: -> 'Du học sinh (Mỹ)'
  avatar: -> 'a.phuong.jpg'
  comment: -> "Bạn sẽ cảm thấy may mắn khi đối thủ của mình chưa biết tới hệ thống này, nó là công cụ tạo ra sự khác biệt cho doanh
               nghiệp của bạn, tôi cá là bạn cũng sẽ bị ấn tượng bởi chức năng trò chuyện công việc giống như tôi."
,
  name: -> 'Nguyễn Ngọc Giàu'
  position: -> 'Chủ nhà hàng New Coffee Bar (Mỹ Tho - Tiền Giang)'
  avatar: -> 'c.giau.jpg'
  comment: -> "Việc kinh doanh của tôi đã thuận lợi hơn rất nhiều, có thể cùng lúc được nhiều việc hơn và tập trung vào tăng trưởng và mở rộng kinh doanh."
#,
#  name: -> 'Đỗ Thụy Vân Quỳnh'
#  position: -> 'Chủ shop thời trang Quỳnh Nhi (Bàu Cát, Tân Bình)'
#  avatar: -> 'no-avatar.jpg'
#  comment: -> "Lúc trước quần áo nhập về quá nhiều nên chuyện tính nhầm giá bán cho khách hàng xảy ra liên tục.
#               Từ khi triển khai EDS, hàng hóa được quản lý rõ ràng hơn, Tôi cũng có nhiều thời gian chăm lo cho gia
#               đình hơn."
]

navigateComment = (step = 1)->
  currentCommentIndex = Session.get('currentCommentPosition')
  console.log currentCommentIndex, comments.length
  currentCommentIndex += step

  if currentCommentIndex >= comments.length
    currentCommentIndex = 0
  else if currentCommentIndex < 0
    currentCommentIndex = comments.length - 1

  Session.set('currentCommentPosition', currentCommentIndex)
  Sky.helpers.animateUsing("#home-comment-wrapper", "fadeIn")

lemon.defineWidget Template.merchantTestimonials,
  currentComment: -> comments[Session.get('currentCommentPosition')]
  created: -> Session.set('currentCommentPosition', 0)
  events:
    'click .nextCommand': -> navigateComment()
    'click .previousCommand': -> navigateComment(-1)