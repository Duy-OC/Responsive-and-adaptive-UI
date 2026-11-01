# Giải thích Adaptive Notes

## 1. Sản phẩm

Ứng dụng ghi chú Flutter dùng dữ liệu mẫu để minh họa Responsive và Adaptive UI. Có thêm/sửa/xóa, chọn màu, hoàn tác. Dữ liệu lưu trong RAM: đổi kích thước không mất dữ liệu trong phiên chạy, nhưng đóng và khởi động lại tiến trình sẽ trở về dữ liệu mẫu.

## 2. Cấu trúc và vai trò từng file

Các đường dẫn dưới đây tính từ lib/.

| File | Trách nhiệm |
|---|---|
| main.dart | main gọi runApp; MaterialApp thiết lập Material 3, theme sáng/tối theo hệ thống; mở HomeScreen |
| models/note.dart | Note bất biến gồm id, title, content, color, updatedAt; preview rút gọn 100 ký tự; copyWith tạo bản mới; == và hashCode so sánh dữ liệu |
| data/sample_notes.dart | 10 ghi chú mẫu, bảng 6 màu; createSampleNotes tạo bản sao danh sách để thêm/xóa độc lập |
| utils/breakpoints.dart | Enum ScreenType; ngưỡng 600dp đổi bố cục; 900dp tăng padding; ngưỡng lưới 400/900dp |
| utils/responsive_helper.dart | gridColumns tính cột; horizontalPadding tính đệm ngang |
| screens/home_screen.dart | Giữ state, xử lý callback, thêm/sửa/xóa/hoàn tác, chọn layout qua LayoutBuilder, Ctrl+N, Back |
| screens/note_detail_screen.dart | Chi tiết cho màn hình hẹp và nút về danh sách; nhúng trong HomeScreen |
| screens/note_edit_screen.dart | Form thêm/sửa; controller tiêu đề/nội dung; chọn màu; validate; Ctrl+S; trả kết quả bằng Navigator.pop |
| layouts/mobile_layout.dart | Danh sách cho không gian hẹp; truyền callback mở/xóa lên HomeScreen |
| layouts/tablet_layout.dart | Row chia danh sách và chi tiết theo flex 2:3; EmptyState khi chưa chọn |
| widgets/note_card.dart | Thẻ tiêu đề, preview, ngày, trạng thái được chọn, nút xóa; InkWell hỗ trợ chạm/hover/con trỏ |
| widgets/note_list.dart | LayoutBuilder đo riêng pane danh sách; GridView.builder; Dismissible vuốt xóa |
| widgets/note_detail_view.dart | Nội dung chi tiết dùng chung; sửa/xóa; SelectableText và cuộn; điều chỉnh padding theo hướng |
| widgets/empty_state.dart | Thông báo khi danh sách rỗng/chưa chọn ghi chú |
| widgets/layout_debug_bar.dart | Thông số chiều rộng vùng bố cục, chiều cao cửa sổ, hướng và loại layout |

Ngoài lib/: test/ chứa kiểm tra model, breakpoint và tương tác; android/ cấu hình Android; docs/ hướng dẫn; pubspec.yaml khai báo tên, SDK và dependencies; analysis_options.yaml cấu hình lint. plan.md là kế hoạch gốc, không phải xác nhận mọi checkpoint đã chạy.

## 3. Luồng khởi động

1. main() → AdaptiveNotesApp → MaterialApp → HomeScreen.
2. HomeScreen tạo danh sách mẫu trong State một lần.
3. LayoutBuilder lấy constraints.maxWidth do widget cha cấp.
4. Breakpoints.fromWidth chọn bố cục.
5. Bố cục truyền dữ liệu vào các widget dùng chung.
6. Người dùng thao tác → callback về HomeScreen → setState → build lại giao diện.

StatefulWidget + setState đủ cho phạm vi này; không cần Provider/BLoC. Widget con nhận dữ liệu và callback thay vì giữ bản sao danh sách riêng.

## 4. Responsive trong ứng dụng

Responsive là điều chỉnh thành phần theo không gian. NoteList dùng LayoutBuilder riêng, trừ padding hai bên rồi truyền bề rộng nội dung vào gridColumns:

| Bề rộng nội dung của vùng danh sách | Số cột |
|---|---:|
| <400dp | 1 |
| 400–899dp | 2 |
| ≥900dp | 3 |

Trên tablet, pane danh sách chỉ chiếm khoảng 40% cửa sổ; do đó không thể lấy bề rộng toàn cửa sổ để quyết định cột bên trong pane nhỏ. Ngưỡng hai cột đổi từ 360 trong kế hoạch sang 400 để thẻ dễ đọc hơn.

Expanded chia không gian; Wrap cho nút/màu xuống dòng; ConstrainedBox giới hạn form 640dp và nội dung chi tiết 720dp; SingleChildScrollView xử lý nội dung dài. Chiều cao thẻ tăng theo textScaler, không ép cỡ chữ người dùng xuống 1.3 như kế hoạch ban đầu.

## 5. Adaptive trong ứng dụng

Dưới 600dp: xem danh sách rồi chuyển sang chi tiết. Từ 600dp: xem danh sách và chi tiết cùng lúc. Đây là thay cách tổ chức màn hình, không chỉ thu/phóng.

Tên MobileLayout/TabletLayout mô tả bố cục, không xác định loại máy. Điện thoại ngang đủ rộng có thể dùng TabletLayout; tablet chia cửa sổ hẹp có thể dùng MobileLayout. Xoay ngang chỉ chuyển layout nếu bề rộng đạt ngưỡng.

## 6. MediaQuery, LayoutBuilder, breakpoint

| Công cụ | Dùng để trả lời | Nơi áp dụng |
|---|---|---|
| LayoutBuilder | Vùng này được widget cha cấp bao nhiêu không gian? | HomeScreen chọn layout; NoteList chọn cột |
| MediaQuery.sizeOf | Cửa sổ/view hiện có kích thước bao nhiêu? | Thanh thông số |
| MediaQuery.orientationOf | Cửa sổ dọc hay ngang? | Thanh thông số, padding chi tiết |
| MediaQuery.textScalerOf | Hệ thống yêu cầu cỡ chữ như thế nào? | Chiều cao thẻ |
| Breakpoint | Tới ngưỡng nào thì thay cách trình bày? | Breakpoints.fromWidth và helper lưới |

Đơn vị là logical pixel, thường gọi dp trong demo; không phải pixel vật lý. MediaQuery phản ánh cửa sổ/view hiện tại, không luôn là toàn màn hình vật lý. LayoutBuilder phù hợp để quyết định bố cục của một vùng con.

## 7. Các hàm quan trọng của HomeScreen

- _selected: tìm Note tương ứng _selectedId; chỉ lưu id để luôn lấy phiên bản dữ liệu mới nhất.
- _open: chọn id, bật xem chi tiết.
- _edit: mở form bằng Navigator.push; nhận Note qua pop; tìm id rồi thêm hoặc thay phần tử; chọn Note vừa lưu. Cờ _editing tránh mở nhiều form khi nhấn phím liên tục.
- _delete: lưu Note và vị trí; xóa; bỏ chọn nếu cần; SnackBar cung cấp hoàn tác. Hoàn tác phục hồi selection nếu không có Note khác đang được chọn.
- build: LayoutBuilder chọn layout; thanh debug bật/tắt bằng nút thông tin.

State ở HomeScreen nằm trên điểm chọn bố cục nên widget rebuild khi resize không tạo lại dữ liệu.

## 8. Form và Back

NoteEditScreen có TextEditingController cho từng ô, khởi tạo từ Note cũ nếu đang sửa. _save bắt buộc tiêu đề không rỗng, tạo Note và trả về qua Navigator.pop. dispose giải phóng cả hai controller.

Form có Scaffold resizeToAvoidBottomInset và vùng cuộn để xử lý bàn phím ảo. Hủy bằng Back không trả Note nên HomeScreen không cập nhật dữ liệu.

Chi tiết trên màn hình hẹp được nhúng vào HomeScreen thay vì push route riêng. Khi rộng lên, không còn route chi tiết cũ che mất bố cục hai vùng. PopScope biến Back hệ thống thành về danh sách khi đang xem chi tiết hẹp. Form vẫn dùng route riêng vì là tác vụ tạm thời có kết quả trả về.

## 9. Phương thức nhập liệu và khả năng đọc

- Cảm ứng: chạm, vuốt sang trái để xóa.
- Chuột: InkWell có hover/con trỏ click; nút xóa thay thế thao tác vuốt.
- Bàn phím: Ctrl+N thêm, Ctrl+S lưu; focus/Tab dùng hành vi mặc định Flutter.
- Nội dung dài: thẻ rút gọn bằng ellipsis; chi tiết xem đầy đủ và chọn văn bản được.
- Theme sáng/tối theo hệ thống; thẻ pastel dùng màu chữ tối để đọc được cả hai theme.
- Nút xóa có vùng tối thiểu 48×48 logical pixel; cỡ chữ theo hệ thống được giữ nguyên.

## 10. Giới hạn

Không có database hoặc đồng bộ. Giữ state khi resize không đồng nghĩa với lưu sau khi tiến trình bị hủy. Widget test không thay thế kiểm thử trên điện thoại thật. Ngưỡng ba cột có logic nhưng thường chỉ đạt ở cửa sổ rất rộng vì pane danh sách chiếm 2/5 cửa sổ; không cần ép hiển thị ba cột để đạt đề bài.
