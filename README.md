# Adaptive Notes — Responsive & Adaptive UI trong Flutter

Ứng dụng ghi chú Flutter minh họa toàn diện **Chủ đề 3: Thiết kế giao diện đa màn hình (Responsive & Adaptive UI)**. Ứng dụng không sử dụng phụ thuộc bên ngoài (third-party packages), tận dụng tối đa các công cụ tích hợp sẵn của Flutter framework (`LayoutBuilder`, `MediaQuery`, `Constraints`, `Shortcuts`, `Actions`, `ThemeData`).

Dữ liệu được quản lý in-memory (RAM) với 10 ghi chú mẫu khởi tạo; hỗ trợ đầy đủ các thao tác CRUD (thêm, sửa, xóa, hoàn tác), bảo toàn trạng thái khi xoay hoặc thay đổi kích thước cửa sổ.

---

## 📑 Mục lục

- [Tính năng nổi bật](#tính-năng-nổi-bật)
- [Nguyên tắc Responsive & Adaptive](#nguyên-tắc-responsive--adaptive)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Hướng dẫn cài đặt & Khởi chạy](#hướng-dẫn-cài-đặt--khởi-chạy)
- [Thao tác & Phím tắt](#thao-tác--phím-tắt)
- [Kiểm thử & Đảm bảo chất lượng](#kiểm-thử--đảm-bảo-chất-lượng)
- [Tài liệu liên quan](#tài-liệu-liên-quan)

---

## ✨ Tính năng nổi bật

- **Bố cục Responsive & Adaptive:**
  - Tự động chuyển đổi giữa bố cục **1 cột danh sách (Mobile Layout)** và **2 vùng Master-Detail (Tablet Layout)** dựa theo bề rộng khả dụng.
  - Vùng danh sách tự động chia **1, 2 hoặc 3 cột** dựa trên bề rộng thực tế của chính nó (`LayoutBuilder`), không phụ thuộc cứng vào kích thước toàn màn hình.
- **Thao tác dữ liệu đầy đủ (CRUD):**
  - Thêm mới ghi chú, chỉnh sửa tiêu đề và nội dung, chọn màu chủ đề từ bảng màu pastel 6 màu.
  - Kiểm tra tính hợp lệ dữ liệu (validation bắt buộc tiêu đề).
  - Xóa ghi chú nhanh bằng nút xóa hoặc cử chỉ vuốt ngang (Dismissible) kèm nút **Hoàn tác (Undo)** qua `SnackBar`.
- **Đa phương thức nhập liệu (Multi-modal input):**
  - **Cảm ứng (Touch):** Chạm mở xem, vuốt để xóa thẻ ghi chú.
  - **Chuột (Mouse):** Hiệu ứng hover, đổi con trỏ chuột (`SystemMouseCursors.click`), nút xóa trực quan thay thế vuốt.
  - **Bàn phím (Keyboard shortcuts):** Hỗ trợ phím tắt `Ctrl + N` (tạo ghi chú mới) và `Ctrl + S` (lưu ghi chú).
- **Trợ năng & Giao diện tối ưu:**
  - Hỗ trợ đầy đủ **Theme sáng / tối (Light / Dark mode)** theo hệ thống với Material 3.
  - Chiều cao thẻ tự động co giãn thích ứng theo hệ số phóng to chữ của người dùng (`MediaQuery.textScalerOf`), đảm bảo không bị tràn chữ (`overflow`).
  - Thanh thông số Layout Debug Bar trực quan hiển thị kích thước cửa sổ, kích thước vùng chứa, hướng màn hình và loại layout hiện tại.

---

## 📐 Nguyên tắc Responsive & Adaptive

### 1. Bố cục màn hình (Master-Detail Breakpoint)
- Áp dụng `LayoutBuilder` ở `HomeScreen` để đo `constraints.maxWidth`:
  - **< 600 dp:** **Mobile Layout** — Hiển thị danh sách; khi chọn một ghi chú, chi tiết mở trên cùng màn hình cha (quản lý qua trạng thái nội bộ và `PopScope` để nút Back quay về danh sách mượt mà).
  - **≥ 600 dp:** **Tablet Layout** — Hiển thị giao diện 2 vùng song song theo tỷ lệ `flex: 2` (danh sách ghi chú) và `flex: 3` (chi tiết ghi chú).

### 2. Lưới thẻ ghi chú thích ứng (Content-width Grid Columns)
- `NoteList` sử dụng `LayoutBuilder` độc lập để đo chính xác bề rộng nội dung sau khi trừ padding ngang:
  - **< 400 dp:** `1 cột` (danh sách dạng dọc, tối ưu cho điện thoại dọc hoặc vùng pane hẹp).
  - **400 – 899 dp:** `2 cột` (lưới 2 cột cân đối).
  - **≥ 900 dp:** `3 cột` (lưới 3 cột thoáng trên màn hình tablet lớn hoặc desktop).

### 3. Giới hạn bề rộng tối đa (Max-width constraints)
- Form tạo/chỉnh sửa (`NoteEditScreen`) được giới hạn độ rộng tối đa **640 dp** và căn giữa (`Center` + `ConstrainedBox`), tránh form bị giãn rộng quá mức trên màn hình lớn.
- Nội dung chi tiết (`NoteDetailView`) được giới hạn bề rộng **720 dp** để duy trì độ dài dòng tối ưu cho việc đọc.

---

## 📂 Cấu trúc dự án

```text
adaptive_notes/
├── android/                   # Cấu hình nền tảng Android
├── docs/                      # Tài liệu chi tiết dự án
│   ├── project_guide.md       # Giải thích kiến trúc, luồng chạy & mã nguồn
│   ├── report_outline.md      # Dàn ý báo cáo & kịch bản demo
│   └── validation.md          # Kết quả kiểm thử và nghiệm thu
├── lib/
│   ├── data/
│   │   └── sample_notes.dart  # 10 ghi chú mẫu và bảng màu pastel
│   ├── layouts/
│   │   ├── mobile_layout.dart # Bố cục cho màn hình hẹp (< 600dp)
│   │   └── tablet_layout.dart # Bố cục 2 vùng Master-Detail (≥ 600dp)
│   ├── models/
│   │   └── note.dart          # Data model bất biến (Immutable Note model)
│   ├── screens/
│   │   ├── home_screen.dart   # Màn hình chính quản lý State, phím tắt & layout
│   │   ├── note_detail_screen.dart # Vỏ bọc chi tiết cho màn hình hẹp
│   │   └── note_edit_screen.dart   # Form thêm/sửa ghi chú có validation
│   ├── utils/
│   │   ├── breakpoints.dart   # Định nghĩa enum ScreenType và các ngưỡng dp
│   │   └── responsive_helper.dart  # Hàm tính số cột và khoảng đệm động
│   ├── widgets/
│   │   ├── empty_state.dart   # Widget hiển thị trạng thái trống
│   │   ├── layout_debug_bar.dart # Thanh hiển thị thông số kích thước và layout
│   │   ├── note_card.dart     # Thẻ ghi chú hỗ trợ hover, con trỏ và nút xóa
│   │   ├── note_detail_view.dart   # Vùng hiển thị chi tiết ghi chú dùng chung
│   │   └── note_list.dart     # Lưới ghi chú thích ứng kèm cử chỉ vuốt xóa
│   └── main.dart              # Điểm khởi chạy ứng dụng & thiết lập ThemeData
├── test/
│   ├── breakpoints_test.dart  # Kiểm thử logic breakpoint & tính toán cột
│   ├── note_test.dart         # Kiểm thử model Note và dữ liệu mẫu
│   └── widget_test.dart       # Kiểm thử giao diện, đổi kích thước, CRUD, phím tắt & trợ năng
├── tool/
│   └── check_layout_rules.dart# Tool kiểm tra tĩnh tính tuân thủ các quy tắc layout
└── pubspec.yaml               # Cấu hình Flutter & dependencies
```

---

## 🚀 Hướng dẫn cài đặt & Khởi chạy

### Yêu cầu môi trường
- Flutter SDK (kênh stable) với Dart SDK tương thích theo `pubspec.yaml`.
- Thiết bị thật hoặc máy ảo (Android Emulator / Chrome / Desktop).

### Các lệnh thực thi

1. **Cài đặt thư viện:**
   ```sh
   flutter pub get
   ```

2. **Kiểm tra phân tích mã nguồn (Static analysis):**
   ```sh
   flutter analyze
   ```

3. **Chạy toàn bộ unit & widget tests:**
   ```sh
   flutter test
   ```

4. **Kiểm tra quy tắc bố cục:**
   ```sh
   dart run tool/check_layout_rules.dart
   ```

5. **Khởi chạy ứng dụng:**
   ```sh
   flutter run
   ```

6. **Đóng gói file cài đặt APK (Android Release):**
   ```sh
   flutter build apk --release
   ```
   > File APK thành phẩm được lưu tại: `build/app/outputs/flutter-apk/app-release.apk`.

---

## ⌨️ Thao tác & Phím tắt

| Thao tác | Mô tả | Nền tảng áp dụng |
|---|---|---|
| **Chạm / Click vào thẻ** | Xem chi tiết ghi chú tương ứng | Cảm ứng, Chuột |
| **Vuốt thẻ sang trái** | Xóa nhanh ghi chú khỏi danh sách | Cảm ứng (Touch) |
| **Nút thùng rác trên thẻ** | Xóa ghi chú trực tiếp bằng click chuột | Chuột, Cảm ứng |
| **Nút "Hoàn tác"** | Phục hồi lại ghi chú vừa xóa từ thanh thông báo | Mọi nền tảng |
| `Ctrl + N` | Mở nhanh màn hình tạo ghi chú mới | Bàn phím |
| `Ctrl + S` | Lưu ghi chú trong màn hình thêm / sửa | Bàn phím |
| **Nút thông tin (Info icon)** | Bật / tắt thanh hiển thị thông số kích thước debug | AppBar |

---

## 🧪 Kiểm thử & Đảm bảo chất lượng

Dự án bao gồm bộ kiểm thử tự động toàn diện:
- **`test/breakpoints_test.dart`**: Kiểm tra ngưỡng đổi bố cục tại 600dp, kiểm tra cách tính cột theo bề rộng thực tế của pane danh sách, khoảng đệm linh hoạt.
- **`test/note_test.dart`**: Đảm bảo tính bất biến của `Note`, rút gọn preview 100 ký tự kèm dấu ba chấm, tính độc lập của danh sách mẫu.
- **`test/widget_test.dart`**: Kiểm tra chuyển đổi bố cục khi thay đổi kích thước cửa sổ không mất lựa chọn; kiểm tra đầy đủ luồng thêm, sửa, xóa, hoàn tác; kiểm tra phím tắt `Ctrl+N`, `Ctrl+S`; kiểm tra không xảy ra lỗi tràn giao diện (`overflow`) ở các kích thước và tỷ lệ phóng chữ từ 1.0× đến 2.0× trên cả theme sáng lẫn tối.
- **`tool/check_layout_rules.dart`**: Kiểm tra 12 quy tắc thiết kế giao diện tự động.

---

## 📚 Tài liệu liên quan

Chi tiết hơn về thiết kế, kịch bản báo cáo và kết quả đánh giá được lưu trong thư mục `docs/`:
- [Giải thích chi tiết cấu trúc & mã nguồn](docs/project_guide.md)
- [Kịch bản demo và dàn ý báo cáo](docs/report_outline.md)
- [Báo cáo trạng thái kiểm tra & nghiệm thu](docs/validation.md)
