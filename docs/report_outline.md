# Dàn ý báo cáo và demo

## Nội dung báo cáo

1. Mục tiêu: ứng dụng ghi chú minh họa Responsive/Adaptive, Flutter/Dart/Material 3.
2. Lý thuyết: co giãn thành phần và thay bố cục; LayoutBuilder, MediaQuery, breakpoint.
3. Thiết kế: HomeScreen giữ state; widget con nhận dữ liệu/callback; hai layout dùng chung thành phần.
4. Triển khai: trích LayoutBuilder trong HomeScreen và NoteList; Breakpoints; MediaQuery.textScalerOf/orientationOf.
5. Demo: hai bố cục, giữ selection, thêm/sửa/xóa/hoàn tác, nhập liệu.
6. Đánh giá: đáp ứng không gian khả dụng; hạn chế dữ liệu RAM; hướng phát triển lưu trữ.

## Demo 4–5 phút

| Bước | Thao tác | Điều cần chỉ ra |
|---|---|---|
| 1 | Mở dọc khoảng 390dp | MOBILE, danh sách ghi chú |
| 2 | Chọn ghi chú | Xem chi tiết và nút Danh sách |
| 3 | Xoay/resize lên ≥600dp | TABLET, hai vùng, giữ ghi chú đã chọn |
| 4 | Thu xuống <600dp | Chi tiết hẹp, không mất dữ liệu |
| 5 | Thêm/sửa, chọn màu và lưu | Form co giãn, cuộn khi bàn phím hiện |
| 6 | Vuốt xóa rồi Hoàn tác | Cảm ứng, dữ liệu cập nhật |
| 7 | Ctrl+N/Ctrl+S nếu có bàn phím | Nhập liệu bàn phím |
| 8 | Tăng cỡ chữ, theme tối | Khả năng đọc và cuộn |

## Ảnh minh chứng trên thiết bị

Tạo docs/screenshots/ và chụp: danh sách dọc; chi tiết dọc; ngang hai vùng; tablet; form mở bàn phím; chữ lớn. Giữ thanh debug để chứng minh điều kiện chuyển layout. Các ảnh widget test nếu có chỉ là ảnh render tự động, không thay thế ảnh chạy trên thiết bị thật.

## Nội dung nói ngắn

“Ứng dụng chọn bố cục theo chiều rộng widget cha cấp qua LayoutBuilder. Dưới 600dp, danh sách và chi tiết được xem lần lượt; từ 600dp cả hai hiển thị cạnh nhau, đây là adaptive. Bên trong danh sách, một LayoutBuilder khác chọn số cột theo bề rộng riêng của vùng đó, đây là responsive. MediaQuery lấy hướng cửa sổ và cỡ chữ hệ thống. Dữ liệu giữ ở HomeScreen nên đổi bố cục không mất ghi chú đang chọn.”
