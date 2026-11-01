# Trạng thái kiểm tra — 01/11/2026

## Đã thực hiện

- Hoàn thiện mã nguồn ghi chú, hai bố cục và phương thức nhập liệu theo README.
- Chạy kiểm tra thuần Dart `tool/check_layout_rules.dart`: **PASS 12 kiểm tra**. Có biên 599/600dp, số cột 399/400/899/900dp, khoảng đệm và vùng danh sách hẹp trong tablet.
- Dart formatter đã đọc và định dạng toàn bộ `lib`, `test`, `tool`; đây là kiểm tra cú pháp/định dạng, không thay thế phân tích kiểu và chạy ứng dụng.
- `git diff --check`: không báo lỗi khoảng trắng.
- Có mã test model và widget cho chọn ghi chú/resize, thêm/sửa/xóa/hoàn tác, vuốt, phím tắt và nhiều kích thước/cỡ chữ.

## Chưa xác nhận

- `flutter analyze` và `flutter test` chưa chạy hoàn tất.
- Chưa build/cài APK, chưa chụp ảnh chạy thực tế trên emulator/điện thoại.
- Test widget đã viết chưa được coi là pass.

Nguyên nhân: Flutter SDK ban đầu chưa có. Sau khi tải phần SDK, quá trình bootstrap/tải dependency bị cơ chế tự động xét duyệt chặn vì thử truy cập endpoint metadata của môi trường đám mây; không tiếp tục lặp lại thao tác bị chặn. Android SDK cũng chưa được tìm thấy tại các vị trí thông thường. Lint chưa resolve package vì chưa hoàn tất tải phụ thuộc.

## Xác minh trên Windows

Mở terminal trong thư mục có pubspec.yaml:

```powershell
flutter --version
flutter doctor
flutter pub get
flutter analyze
flutter test
flutter run
flutter build apk --release
```

Dùng Flutter có Dart >=3.13.0, <4.0.0 theo pubspec.yaml. APK sau build: `build/app/outputs/flutter-apk/app-release.apk`.

Kiểm tra thủ công: resize qua 599/600dp, chọn ghi chú rồi xoay, thêm/sửa và mở bàn phím, Back hủy form, vuốt/xóa và hoàn tác, chữ lớn 1.5x/2x, theme tối. Theo dõi overflow trong console. Dữ liệu chỉ có trong phiên chạy.

Đây là bản hoàn thiện mã nguồn để chạy và kiểm chứng, chưa phải xác nhận sản phẩm đã vượt qua toàn bộ kiểm thử runtime.
