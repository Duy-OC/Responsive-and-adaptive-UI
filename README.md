# Adaptive Notes — Ứng dụng ghi chú Responsive & Adaptive UI

Ứng dụng ghi chú viết bằng **Flutter**, minh họa đầy đủ chủ đề **Thiết kế giao diện đa màn hình (Responsive & Adaptive UI)**: bố cục tự động chuyển đổi theo kích thước cửa sổ, lưới nội dung co giãn theo bề rộng thực tế, hỗ trợ cảm ứng – chuột – bàn phím, và tối ưu cho theme sáng/tối cùng cỡ chữ phóng to.

Dự án **không sử dụng bất kỳ package bên thứ ba nào** ở runtime; toàn bộ được xây dựng bằng các API có sẵn của Flutter (`LayoutBuilder`, `MediaQuery`, `Constraints`, `Shortcuts`, `Actions`, `ThemeData`).

---

## 1. Tổng quan

| Thông tin | Giá trị |
|---|---|
| **Tên ứng dụng** | Adaptive Notes |
| **Phiên bản** | `1.0.0+1` (versionCode 1, versionName 1.0.0) |
| **Nền tảng** | Android (APK release), hỗ trợ chạy Web/Desktop khi phát triển |
| **Ngôn ngữ** | Dart |
| **Dữ liệu** | In-memory (RAM), 10 ghi chú mẫu, đầy đủ CRUD |
| **APK đóng gói sẵn** | [`release/adaptive_notes-v1.0.0-release.apk`](release/adaptive_notes-v1.0.0-release.apk) (~46.5 MB) |

**Mục tiêu của dự án:**

- Áp dụng `LayoutBuilder` để chọn bố cục **Mobile** hoặc **Tablet** theo bề rộng khả dụng.
- Xây dựng lưới ghi chú tự động chia **1 / 2 / 3 cột** dựa trên bề rộng của chính vùng chứa.
- Đảm bảo giao diện không tràn (`overflow`) khi xoay màn hình, đổi kích thước cửa sổ hoặc tăng cỡ chữ hệ thống.
- Hỗ trợ đa phương thức nhập liệu: chạm, chuột và phím tắt.

---

## 2. Tính năng chính

### 2.1. Bố cục Responsive & Adaptive

| Bề rộng khả dụng | Bố cục | Mô tả |
|---|---|---|
| `< 600 dp` | **Mobile Layout** | Danh sách ghi chú toàn màn hình; chọn ghi chú sẽ mở màn hình chi tiết, nút Back quay về danh sách (xử lý qua `PopScope`). |
| `≥ 600 dp` | **Tablet Layout** | Hai vùng song song **Master–Detail** theo tỷ lệ `flex: 2` (danh sách) và `flex: 3` (chi tiết). |

Lưới ghi chú (`NoteList`) tự đo bề rộng nội dung bằng `LayoutBuilder`:

| Bề rộng vùng danh sách | Số cột |
|---|---|
| `< 400 dp` | 1 cột |
| `400 – 899 dp` | 2 cột |
| `≥ 900 dp` | 3 cột |

Ngoài ra, form thêm/sửa được giới hạn tối đa **640 dp** và nội dung chi tiết **720 dp**, căn giữa để đảm bảo độ dài dòng dễ đọc trên màn hình lớn.

### 2.2. Quản lý ghi chú (CRUD)

- Thêm mới ghi chú với tiêu đề, nội dung và màu chủ đề (6 màu pastel).
- Chỉnh sửa tiêu đề/nội dung, có kiểm tra hợp lệ (bắt buộc nhập tiêu đề).
- Xóa bằng nút thùng rác hoặc vuốt ngang thẻ (`Dismissible`).
- **Hoàn tác (Undo)** ghi chú vừa xóa thông qua `SnackBar`.
- Giữ nguyên ghi chú đang chọn khi xoay màn hình hoặc thay đổi kích thước cửa sổ.

### 2.3. Đa phương thức nhập liệu

- **Cảm ứng:** chạm để mở, vuốt để xóa.
- **Chuột:** hiệu ứng hover, đổi con trỏ (`SystemMouseCursors.click`), nút xóa trực quan.
- **Bàn phím:** `Ctrl + N` tạo ghi chú mới, `Ctrl + S` lưu ghi chú.

### 2.4. Trợ năng & giao diện

- Material 3 với **theme sáng/tối** theo cài đặt hệ thống.
- Chiều cao thẻ co giãn theo hệ số phóng to chữ (`MediaQuery.textScalerOf`), không tràn nội dung.
- **Layout Debug Bar** hiển thị kích thước cửa sổ, kích thước vùng chứa, hướng màn hình và loại bố cục hiện tại.

### 2.5. Kiểm thử tự động

- 13 bài kiểm thử unit + widget, bao quát breakpoint, model, CRUD, phím tắt, resize và overflow.
- Công cụ kiểm tra tĩnh 12 quy tắc thiết kế bố cục.

---

## 3. Công nghệ sử dụng

| Thành phần | Công nghệ / Phiên bản |
|---|---|
| **Framework** | Flutter 3.47.7 (stable) |
| **Ngôn ngữ** | Dart 3.13.5 (ràng buộc `^3.13.0`) |
| **UI** | Material 3, `ColorScheme.fromSeed`, hỗ trợ Light/Dark theme |
| **Quản lý trạng thái** | `StatefulWidget` + `setState` (không dùng package ngoài) |
| **Thư viện runtime** | Không có third-party package |
| **Kiểm thử & lint** | `flutter_test`, `flutter_lints ^6.0.0` |
| **Build Android** | Gradle 9.3.1, Android Gradle Plugin (Kotlin DSL), JDK 17 |
| **Định dạng dữ liệu** | Model bất biến (`Note`) với `copyWith` |

---

## 4. Điều kiện tiên quyết

Trước khi chạy dự án, hãy đảm bảo máy đã cài đặt:

1. **Flutter SDK (stable)** với Dart `>= 3.13.0 < 4.0.0`.
   ```bash
   flutter --version
   ```
2. **Android SDK** (platform & build-tools phù hợp) nếu muốn build APK.
   ```bash
   flutter doctor
   ```
3. **JDK 17 trở lên** (có thể dùng JDK đi kèm Android Studio).
4. **Thiết bị/emulator Android** đã bật chế độ nhà phát triển và USB debugging (hoặc Chrome/Edge nếu chạy bản web).
5. Đã chấp nhận giấy phép Android:
   ```bash
   flutter doctor --android-licenses
   ```

> Nếu `flutter doctor` báo thiếu thành phần nào, hãy xử lý theo hướng dẫn trước khi tiếp tục.

---

## 5. Hướng dẫn cài đặt

### 5.1. Clone mã nguồn

```bash
git clone https://github.com/Duy-OC/Responsive-and-adaptive-UI.git
cd Responsive-and-adaptive-UI
```

### 5.2. Cài đặt dependency

```bash
flutter pub get
```

### 5.3. Chạy ứng dụng ở chế độ phát triển

```bash
flutter run
```

Flutter sẽ tự phát hiện thiết bị/emulator đang kết nối. Có thể chỉ định thiết bị:

```bash
flutter devices
flutter run -d <device-id>
```

### 5.4. Build APK release

```bash
flutter build apk --release
```

File APK được tạo tại:

```text
build/app/outputs/flutter-apk/app-release.apk
```

### 5.5. Sử dụng APK đóng gói sẵn

Bản APK đã build thành công được lưu trong thư mục [`release/`](release/):

- **Đường dẫn:** [`release/adaptive_notes-v1.0.0-release.apk`](release/adaptive_notes-v1.0.0-release.apk)
- **Cài đặt qua ADB:**
  ```bash
  adb install -r release/adaptive_notes-v1.0.0-release.apk
  ```
- **Cài đặt thủ công:** chép file APK sang thiết bị Android, bật *"Cài đặt từ nguồn không xác định"* nếu được yêu cầu, sau đó mở file để cài.
- **Lưu ý:** APK hiện được ký bằng **debug keystore** (cấu hình mặc định của Flutter), phù hợp cho mục đích demo và học tập. Khi phát hành chính thức cần cấu hình signing riêng.

---

## 6. Cách sử dụng

### 6.1. Các thao tác cơ bản

1. **Xem chi tiết:** chạm/click vào một thẻ ghi chú.
2. **Thêm ghi chú:** nhấn nút `+` (hoặc `Ctrl + N`), nhập tiêu đề/nội dung, chọn màu rồi lưu.
3. **Sửa ghi chú:** mở ghi chú → nhấn nút chỉnh sửa → cập nhật → lưu (`Ctrl + S`).
4. **Xóa ghi chú:** nhấn nút thùng rác hoặc vuốt thẻ sang trái.
5. **Hoàn tác:** nhấn **"Hoàn tác"** trên thanh thông báo vừa hiện.
6. **Xem thông số bố cục:** nhấn biểu tượng thông tin trên AppBar để bật/tắt Layout Debug Bar.

### 6.2. Phím tắt

| Phím tắt | Chức năng | Nền tảng |
|---|---|---|
| `Ctrl + N` | Mở màn hình tạo ghi chú mới | Bàn phím |
| `Ctrl + S` | Lưu ghi chú đang chỉnh sửa | Bàn phím |

### 6.3. Trải nghiệm bố cục thích ứng

- **Trên điện thoại:** xoay dọc/ngang để thấy giao diện chuyển giữa danh sách và chi tiết.
- **Trên tablet/desktop:** kéo giãn cửa sổ qua ngưỡng **600 dp** để chuyển từ bố cục 1 cột sang Master–Detail.
- **Kiểm tra trợ năng:** tăng cỡ chữ hệ thống lên 1.5×–2× và chuyển theme tối để xác nhận giao diện không bị tràn.

### 6.4. Kiểm tra chất lượng mã nguồn

```bash
# Phân tích tĩnh
flutter analyze

# Chạy toàn bộ unit & widget tests
flutter test

# Kiểm tra 12 quy tắc bố cục
dart run tool/check_layout_rules.dart
```

**Trạng thái hiện tại:** `flutter analyze` không phát hiện lỗi, toàn bộ **13/13** bài kiểm thử đạt, 12/12 quy tắc bố cục đạt, và APK release đã build thành công.

---

## 7. Cấu trúc thư mục

```text
adaptive_notes/
├── android/                        # Cấu hình nền tảng Android (Gradle Kotlin DSL)
├── docs/                           # Tài liệu chi tiết dự án
│   ├── project_guide.md            # Kiến trúc, luồng chạy và giải thích mã nguồn
│   ├── report_outline.md           # Dàn ý báo cáo và kịch bản demo
│   └── validation.md               # Kết quả kiểm thử và nghiệm thu
├── lib/
│   ├── data/
│   │   └── sample_notes.dart       # 10 ghi chú mẫu và bảng màu pastel
│   ├── layouts/
│   │   ├── mobile_layout.dart      # Bố cục màn hình hẹp (< 600 dp)
│   │   └── tablet_layout.dart      # Bố cục Master–Detail (≥ 600 dp)
│   ├── models/
│   │   └── note.dart               # Model bất biến của ghi chú
│   ├── screens/
│   │   ├── home_screen.dart        # State, phím tắt và điều phối bố cục
│   │   ├── note_detail_screen.dart # Màn hình chi tiết cho thiết bị hẹp
│   │   └── note_edit_screen.dart   # Form thêm/sửa có validation
│   ├── utils/
│   │   ├── breakpoints.dart        # Enum ScreenType và các ngưỡng dp
│   │   └── responsive_helper.dart  # Tính số cột và khoảng đệm động
│   ├── widgets/
│   │   ├── empty_state.dart        # Trạng thái danh sách trống
│   │   ├── layout_debug_bar.dart   # Thanh thông số kích thước/bố cục
│   │   ├── note_card.dart          # Thẻ ghi chú (hover, con trỏ, nút xóa)
│   │   ├── note_detail_view.dart   # Vùng hiển thị chi tiết dùng chung
│   │   └── note_list.dart          # Lưới ghi chú thích ứng + vuốt xóa
│   └── main.dart                   # Điểm khởi chạy và cấu hình theme
├── release/
│   └── adaptive_notes-v1.0.0-release.apk  # APK release đóng gói sẵn
├── report/                         # Slide báo cáo (LaTeX + PDF)
├── test/
│   ├── breakpoints_test.dart       # Kiểm thử breakpoint và số cột
│   ├── note_test.dart              # Kiểm thử model và dữ liệu mẫu
│   └── widget_test.dart            # Kiểm thử giao diện, CRUD, phím tắt, overflow
├── tool/
│   └── check_layout_rules.dart     # Kiểm tra tĩnh 12 quy tắc bố cục
├── analysis_options.yaml           # Cấu hình lint
├── pubspec.yaml                    # Khai báo package và phiên bản
└── README.md
```

Tài liệu tham khảo thêm:

- [Giải thích chi tiết cấu trúc & mã nguồn](docs/project_guide.md)
- [Kịch bản demo và dàn ý báo cáo](docs/report_outline.md)
- [Báo cáo trạng thái kiểm tra & nghiệm thu](docs/validation.md)

---

## 9. Giấy phép

Dự án được thực hiện cho **mục đích học tập và báo cáo môn học** về Responsive & Adaptive UI. Repository hiện **chưa bao gồm tệp `LICENSE` chính thức**; mọi quyền sử dụng mã nguồn thuộc về tác giả.

- Được phép đọc, tham khảo và học hỏi từ mã nguồn.
- Vui lòng liên hệ tác giả nếu muốn sử dụng lại cho mục đích khác hoặc phát hành thương mại.
- Thư viện **Flutter** sử dụng trong dự án được phát hành theo giấy phép **BSD-3-Clause** của Google.
