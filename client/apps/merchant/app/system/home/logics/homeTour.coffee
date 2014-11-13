tourSteps = [
#  element: ".navbar.main"
#  placement: "bottom"
#  title: "Chào mừng Bạn đến với <b>Thiên Ban</b>!"
#  content: "Cảm ơn Bạn đã tin tưởng và sử dụng dịch vụ EDS của chúng tôi,
#            Trước tiên, chúng tôi có đôi điều muốn chia sẽ cùng Bạn về quan niệm sử dụng hệ thống quản lý. Như Bạn cũng
#            biết, lâu nay cụm từ cài đặt phần mềm có thể đã quen thuộc với nhiều người, cài đặt vào máy và cứ thế sử dụng.
#            Tuy nhiên, thời gian sử dụng hiệu quả sẽ diễn ra bao lâu và lợi ích thật sự mà bạn nhận được là gì? Câu hỏi
#            này khiến cả Thế giới phải suy ngẫm, khi mà người làm kinh doanh muốn có được một nguồn lực tự động mạnh mẽ
#            nhất thì đây là áp lực thôi thúc người làm công nghệ phải tạo ra một xu hướng mới. Sự phổ biến của các sản
#            phẩm công nghệ cao trong thời gian qua là minh chứng rõ nét cho sự phát triển vô cùng mạnh mẽ của công nghệ.
#            Có thể nói, sau 1 vài năm thì công nghệ của phần mềm cài đặt đó đã lỗi thời so với sự tiến bộ chung, phần mềm
#            này không còn đáp ứng được hiệu quả kinh doanh. Hơn nữa, khi có những sai lỗi kỹ thuật trong quá trình sử dụng,
#            Bạn sẽ khó khăn trong việc bảo trì, Bạn có thể phải tốn kém thêm chi phí cho bên cung ứng. Khi đó, Bạn phải
#            làm gì với phần mềm này, tiếp tục sử dụng một sản phẩm lỗi thời, không mang lại hiệu quả hay từ bỏ nó, tất
#            cả những việc này điều làm gián đoạn công việc kinh doanh của Bạn và tất nhiên là chi phí cài đặt ban đầu khá cao.<br/>
#            Trong xu hướng ứng dụng hệ thống quản lý hiện đại, chúng tôi muốn làm rõ hơn về quan niệm sử dụng này và thật
#            sự muốn mang đến cho Bạn một nguồn lực kinh doanh mới, mạnh mẽ, chính xác và triệt để (không còn phải đau đầu
#            với đống sổ sách, không mơ hồ khó hiểu về hệ thống quản lý). Hệ thống EDS được phát triển trên nền tảng website
#            sẽ giải quyết được những vướng mắc mà phần mềm cài đặt không giải quyết được, ví dụ như là quản lý từ xa, quản
#            lý cùng lúc nhiều điểm kinh doanh, làm việc trên hệ thống mọi lúc mọi nơi, làm việc nhóm… <br/>
#            Đặc biệt, Bạn nhất định sẽ không cảm thấy đơn độc trong quá trình sử dụng, vì có tổng đài chăm sóc khách hàng
#            24/24 của chúng tôi. Tổng đài sẽ luôn sẵn sàng để hướng dẫn và hỗ trợ Bạn. Đồng thời, Bạn luôn được sử dụng
#            hệ thống quản lý hiện đại nhất mà không phải mất thêm bất kỳ khoản chi phí phát sinh nào.<br/>
#            Chúc Bạn có nhiều trải nghiệm thú vị!"
#,
  element: ".tour-toggle"
  placement: "bottom"
  title: "Chào mừng bạn đến với hệ thống <b>EDS!</b>"
  content: "<b>Đ</b>ây là chức năng hướng dẫn sử dụng, sau lần đăng nhập đầu tiên, hệ thống <b>EDS</b> sẽ không tự động bật <b>HƯỚNG DẪN SỬ DỤNG</b>
            nữa.<br/><b>T</b>uy nhiên bạn vẫn có thể xem lại hướng dẫn bằng cách ấn vào biểu tượng phía trên."
,
  element: ".chat-avatar.me"
  placement: "left"
  title: "Hệ thống trò chuyện."
  content: "<b>P</b>hía bên trái màn hình là <b>hệ thống trò chuyện</b>, đây là nơi mà bạn sẽ tương tác, quan sát
            và theo dõi tình trạng kết nối của các đồng nghiệp.<br/><br/>
            <b>Đ</b>iều tuyệt vời này, gia tăng sự tương tác và <b>cảm hứng</b> làm việc của bạn.<br/><br/>
            <b>B</b>iểu tượng đang được <b>tô sáng</b> là ảnh đại diện và tình trạng kết nối của bạn.
            Tương tự, phía dưới là tình trạng kết nối của <b>đồng nghiệp</b>."
,
  element: ".collapse-toggle"
  placement: "left"
  title: "An giao dien tro chuyen (1)"
  content: "Content of my stepasd asdas d"
,
  element: ".collapse-toggle"
  placement: "left"
  title: "An giao dien tro chuyen (2)"
  content: "Content of my stepasd asdas d"
,
  element: "[data-app='staffManager']"
  title: "Title of my step"
  content: "Content of my step"
#,
#  element: "[data-app='staffManager']"
#  title: "Title of my step"
#  content: "Content of my step"
#,
#  element: "[data-app='staffManager']"
#  title: "Title of my step"
#  content: "Content of my step"
#,
#  element: "[data-app='staffManager']"
#  title: "Title of my step"
#  content: "Content of my step"
]

Apps.Merchant.homeRerun.push (scope) ->
  scope.homeTour = new Tour
    steps: tourSteps
    container: "body"
    backdrop: true

  Apps.currentTour = scope.homeTour