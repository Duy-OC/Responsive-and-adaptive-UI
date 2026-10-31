# PLAN.md — Adaptive Notes (Flutter / Dart)

> Tài liệu này là **chỉ thị làm việc cho Agent**. Hãy đọc toàn bộ trước khi bắt đầu, sau đó thực hiện lần lượt từng Phase. Không bỏ qua bước kiểm tra (Checkpoint) ở cuối mỗi Phase.

---

## 0. Bối cảnh & mục tiêu

**Môn/chủ đề:** Chủ đề 3 — Responsive và Adaptive UI.

**Đề tài:** App Ghi chú (Notes) có giao diện thích ứng, chạy trên **điện thoại Android**, xuất được file **APK**.

**Yêu cầu của đề (phải thể hiện được trong app và báo cáo):**

| # | Yêu cầu | Cách đáp ứng trong app |
|---|---|---|
| 1 | Phân biệt responsive và adaptive | Responsive: `GridView` đổi số cột, widget co giãn. Adaptive: đổi hẳn bố cục 1 cột ↔ 2 cột (master-detail) |
| 2 | Dùng `MediaQuery`, `LayoutBuilder`, breakpoint | `LayoutBuilder` chọn layout; `MediaQuery` lấy orientation, textScale, padding; breakpoint tập trung 1 file |
| 3 | Nguyên tắc thiết kế nhiều kích thước và phương thức nhập liệu | Cảm ứng (chạm, vuốt xóa), bàn phím ảo (`TextField`), phím tắt và hover (nếu có bàn phím/chuột) |
| 4 | Giao diện thích ứng ≥ 2 kích thước/điều kiện | Điện thoại dọc (<600dp) và điện thoại ngang/tablet (≥600dp) |
| 5 | Minh họa chọn bố cục theo không gian khả dụng | `LayoutBuilder` dựa trên `constraints.maxWidth`, kèm thanh debug hiển thị kích thước hiện tại |

**Sản phẩm bàn giao:**
1. Source code Flutter chạy được, `flutter analyze` sạch lỗi.
2. File `app-release.apk`.
3. Ảnh chụp màn hình ≥ 4 trạng thái (xem Phase 8).
4. Dàn ý báo cáo `docs/report_outline.md`.

---

## 1. Ràng buộc kỹ thuật (BẮT BUỘC tuân thủ)

- Ngôn ngữ: **Dart 3.x**, framework **Flutter stable**, UI **Material 3** (`useMaterial3: true`).
- **Không dùng package ngoài** (chỉ dùng thư viện có sẵn của Flutter). Lý do: dễ build APK, dễ giải thích trong báo cáo.
- Dữ liệu: **lưu trong bộ nhớ (in-memory)**, dùng dữ liệu mẫu. Không database, không mạng.
- Quản lý state: dùng `StatefulWidget` + `setState` đặt ở `HomeScreen` (đủ cho đề tài).
- Comment trong code bằng **tiếng Việt**, ngắn gọn, giải thích *vì sao* chứ không chỉ *cái gì*. Đặc biệt comment kỹ ở nơi dùng `LayoutBuilder`, `MediaQuery`, breakpoint.
- Tên file/biến/lớp dùng tiếng Anh, theo quy ước Dart (`snake_case.dart`, `UpperCamelCase`, `lowerCamelCase`).
- Dùng `const` constructor ở mọi nơi có thể.
- **Tuyệt đối không hardcode kích thước theo pixel của một thiết bị cụ thể.** Mọi ngưỡng đều lấy từ `Breakpoints`.
- Mục tiêu nền tảng: Android. Không cần cấu hình iOS/Web.

---

## 2. Cấu trúc thư mục đích

```
adaptive_notes/
├── pubspec.yaml
├── plan.md
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── note.dart
│   ├── data/
│   │   └── sample_notes.dart
│   ├── utils/
│   │   ├── breakpoints.dart
│   │   └── responsive_helper.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── note_detail_screen.dart
│   │   └── note_edit_screen.dart
│   ├── layouts/
│   │   ├── mobile_layout.dart
│   │   └── tablet_layout.dart
│   └── widgets/
│       ├── note_card.dart
│       ├── note_list.dart
│       ├── note_detail_view.dart
│       ├── empty_state.dart
│       └── layout_debug_bar.dart      # (thêm) thanh hiển thị thông số để demo
├── test/
│   └── widget_test.dart
└── docs/
    ├── screenshots/
    ├── report_outline.md
    └── app-release.apk
```

> `layout_debug_bar.dart` là file bổ sung so với cấu trúc ban đầu, phục vụ demo trực quan.

---

## 3. Luồng hoạt động tổng thể

```
main.dart → MaterialApp → HomeScreen (StatefulWidget: giữ danh sách notes + selectedId)
                              │
                         LayoutBuilder  (đọc constraints.maxWidth)
                              ├─ maxWidth < 600  → MobileLayout
                              │        NoteList (GridView 1–2 cột) → bấm → NoteDetailScreen (push)
                              └─ maxWidth ≥ 600  → TabletLayout
                                       [ NoteList (trái) | NoteDetailView (phải) ]
```

**Quy tắc quan trọng:** state (`notes`, `selectedId`) nằm **trên** `LayoutBuilder` (trong `HomeScreen`) để khi xoay màn hình hoặc đổi layout thì **không mất dữ liệu / không mất ghi chú đang chọn**.

---

## 4. Đặc tả chi tiết từng file

### 4.1 `models/note.dart`
- Lớp `Note` immutable với các trường: `String id`, `String title`, `String content`, `Color color`, `DateTime updatedAt`.
- Có `copyWith(...)`.
- Có getter `String preview` trả về 100 ký tự đầu của `content` (thêm `…` nếu bị cắt).

### 4.2 `data/sample_notes.dart`
- Hàm/biến trả về `List<Note>` gồm **10 ghi chú mẫu bằng tiếng Việt**, nội dung thực tế (học tập, mua sắm, ý tưởng, lịch hẹn…).
- Độ dài nội dung **khác nhau** (có note 1 dòng, có note dài vài đoạn) để kiểm tra co giãn và cuộn.
- Màu lấy từ một bảng pastel nhỏ (6 màu).

### 4.3 `utils/breakpoints.dart`
```dart
enum ScreenType { mobile, tablet }

class Breakpoints {
  Breakpoints._();

  /// Từ ngưỡng này trở lên dùng bố cục 2 cột (master-detail).
  static const double tablet = 600;

  /// Ngưỡng phụ: màn hình rất rộng, tăng số cột lưới / mở rộng panel.
  static const double wide = 900;

  static ScreenType fromWidth(double width) =>
      width >= tablet ? ScreenType.tablet : ScreenType.mobile;
}
```
- Có comment giải thích vì sao chọn 600 (theo Material 3: compact < 600).

### 4.4 `utils/responsive_helper.dart`
- `int gridColumns(double availableWidth)`: trả số cột theo **chiều rộng của chính vùng chứa danh sách** (không phải chiều rộng màn hình).
  - `< 360` → 1 cột; `360–599` → 2 cột; `600–899` → 2 cột; `≥ 900` → 3 cột. (Với pane danh sách trong tablet, rộng khoảng 320–420 → 1 cột; Agent kiểm tra lại và điều chỉnh để hợp lý.)
- `double horizontalPadding(double width)`: 12 / 16 / 24 theo mức.
- `double textScaleClamp(BuildContext)`: dùng `MediaQuery.textScalerOf(context)` để minh họa đọc `textScale`; trả về hệ số đã giới hạn (ví dụ tối đa 1.3) để layout không vỡ khi người dùng bật chữ lớn.

### 4.5 `main.dart`
- `MaterialApp` với `title: 'Adaptive Notes'`, `debugShowCheckedModeBanner: false`.
- Theme sáng + tối (`ColorScheme.fromSeed`), `themeMode: ThemeMode.system`.
- `home: const HomeScreen()`.

### 4.6 `screens/home_screen.dart` — **file trọng tâm của đề tài**
- `StatefulWidget` giữ: `List<Note> _notes`, `String? _selectedId`.
- Các hàm: `_select(String id)`, `_addNote()`, `_updateNote(Note)`, `_deleteNote(String id)` (xóa xong hiện `SnackBar` có nút **Hoàn tác**).
- `build` dùng **`LayoutBuilder`**:
  ```dart
  return LayoutBuilder(
    builder: (context, constraints) {
      // Chọn bố cục theo KHÔNG GIAN KHẢ DỤNG (constraints), không theo loại thiết bị.
      final type = Breakpoints.fromWidth(constraints.maxWidth);
      return Scaffold(
        appBar: AppBar(title: const Text('Ghi chú')),
        body: Column(children: [
          LayoutDebugBar(width: constraints.maxWidth, type: type),
          Expanded(child: type == ScreenType.tablet ? TabletLayout(...) : MobileLayout(...)),
        ]),
        floatingActionButton: FloatingActionButton(onPressed: _addNote, child: const Icon(Icons.add)),
      );
    },
  );
  ```
- Phải có comment tiếng Việt giải thích: tại sao dùng `LayoutBuilder` thay vì `MediaQuery` (xem mục 7).
- Hỗ trợ phím tắt (tùy chọn nhưng nên làm): bọc body bằng `CallbackShortcuts` — `Ctrl+N` thêm ghi chú mới.

### 4.7 `layouts/mobile_layout.dart`
- Nhận: `notes`, callbacks `onOpen(Note)`, `onDelete(Note)`.
- Hiển thị `NoteList`. Bấm vào ghi chú → `Navigator.push` sang `NoteDetailScreen`.

### 4.8 `layouts/tablet_layout.dart`
- `Row` gồm:
  - Trái: `SizedBox`/`Flexible(flex: 2)` chứa `NoteList` (có `VerticalDivider` bên phải).
  - Phải: `Expanded(flex: 3)` chứa `NoteDetailView` của ghi chú đang chọn; nếu chưa chọn → `EmptyState`.
- Dùng `AnimatedSwitcher` khi đổi ghi chú được chọn (hiệu ứng nhẹ).

### 4.9 `widgets/note_list.dart`
- Dùng **`LayoutBuilder` thứ hai** bên trong để lấy chiều rộng của chính pane danh sách → gọi `gridColumns(...)`.
- `GridView.builder` (hoặc `ListView` khi 1 cột), `childAspectRatio` hợp lý, hoặc dùng cách không phụ thuộc tỉ lệ cố định để tránh overflow khi chữ lớn.
- Mỗi item bọc `Dismissible` (vuốt để xóa — nhập liệu cảm ứng).
- Highlight ghi chú đang được chọn (chỉ có ý nghĩa ở tablet layout).

### 4.10 `widgets/note_card.dart`
- Thẻ hiển thị: tiêu đề (tối đa 1–2 dòng, `ellipsis`), preview (tối đa 3 dòng), ngày cập nhật (định dạng `dd/MM/yyyy`, tự viết, không dùng package `intl`).
- `InkWell` có hiệu ứng chạm; bọc thêm `MouseRegion` để đổi con trỏ + hiệu ứng hover khi có chuột.
- Kích thước tối thiểu của vùng chạm ≥ 48dp.

### 4.11 `widgets/note_detail_view.dart`
- Widget **dùng lại cho cả hai layout** (tablet nhúng trực tiếp; mobile bọc trong `NoteDetailScreen`).
- Hiển thị tiêu đề lớn, ngày, nội dung (`SingleChildScrollView` + `SelectableText`), nút **Sửa** và **Xóa**.
- Đọc `MediaQuery.orientationOf(context)`: nếu ngang thì giảm padding dọc/cỡ tiêu đề để vừa màn hình thấp.

### 4.12 `screens/note_detail_screen.dart`
- `Scaffold` + `AppBar` chứa `NoteDetailView`. Dùng cho điện thoại dọc.
- **Edge case:** nếu người dùng đang ở màn này rồi xoay ngang (chuyển sang tablet layout), màn hình vẫn phải hoạt động bình thường, không crash, không mất dữ liệu.

### 4.13 `screens/note_edit_screen.dart`
- Form thêm/sửa: `TextField` tiêu đề, `TextField` nội dung (`maxLines: null`, `keyboardType: TextInputType.multiline`), chọn màu (hàng `ChoiceChip` hoặc `Wrap`).
- Dùng `Scaffold(resizeToAvoidBottomInset: true)` và `SingleChildScrollView` để bàn phím ảo không che nội dung.
- Nút **Lưu** trên AppBar; `Ctrl+S` để lưu nếu có bàn phím vật lý.
- Trên màn hình rộng (≥ 600): giới hạn bề rộng form bằng `ConstrainedBox(maxWidth: 640)` và căn giữa (minh họa nguyên tắc "không để nội dung giãn quá rộng").

### 4.14 `widgets/empty_state.dart`
- Icon lớn + dòng chữ "Chọn một ghi chú để xem" (dùng khi tablet chưa chọn), và biến thể "Chưa có ghi chú nào" khi danh sách rỗng.

### 4.15 `widgets/layout_debug_bar.dart`
- Thanh nhỏ ở đầu màn hình hiển thị: `Rộng: 411dp | Cao: 843dp | Hướng: dọc | Layout: MOBILE`.
- Lấy `width` từ tham số (từ `LayoutBuilder`), `height` và `orientation` từ `MediaQuery.sizeOf/orientationOf`.
- Có hằng `const bool kShowDebugBar = true;` để tắt khi quay video/chụp bản cuối.
- Mục đích: khi demo, người chấm nhìn thấy ngay bố cục đổi theo ngưỡng nào.

---

## 5. Các Phase thực hiện

> Quy tắc: sau **mỗi Phase** chạy `flutter analyze` và `flutter run` (hoặc ít nhất build thử). Chỉ sang Phase kế tiếp khi không còn lỗi.

### Phase 1 — Khởi tạo dự án
**Việc làm:**
1. Chạy `flutter --version` và `flutter doctor` để xác nhận môi trường; báo lại nếu thiếu Android SDK.
2. `flutter create adaptive_notes --org com.example --platforms android`
3. Tạo toàn bộ thư mục và file rỗng theo mục 2.
4. Dọn `main.dart` mặc định (xóa counter demo).

**Checkpoint:** `flutter run` hiển thị được màn hình trống không lỗi.

### Phase 2 — Model & dữ liệu mẫu
**Việc làm:** viết `note.dart`, `sample_notes.dart` (mục 4.1, 4.2).
**Checkpoint:** `flutter analyze` sạch; in thử danh sách mẫu ra console OK.

### Phase 3 — Breakpoint & helper
**Việc làm:** viết `breakpoints.dart`, `responsive_helper.dart` (mục 4.3, 4.4).
**Checkpoint:** viết **unit test** trong `test/` cho `Breakpoints.fromWidth` (599 → mobile, 600 → tablet, 900 → tablet) và `gridColumns`. `flutter test` pass.

### Phase 4 — Widget dùng chung
**Việc làm:** `note_card.dart`, `note_list.dart`, `note_detail_view.dart`, `empty_state.dart`, `layout_debug_bar.dart`.
**Checkpoint:** dựng thử từng widget trong màn hình tạm, không overflow (không có dải sọc vàng-đen).

### Phase 5 — Hai layout
**Việc làm:** `mobile_layout.dart`, `tablet_layout.dart`, `note_detail_screen.dart` (mục 4.7, 4.8, 4.12).
**Checkpoint:** từng layout hiển thị đúng khi gắn thủ công.

### Phase 6 — HomeScreen + LayoutBuilder (trọng tâm)
**Việc làm:** viết `home_screen.dart` (mục 4.6), nối `main.dart`.
**Checkpoint (phải kiểm tra thực tế trên emulator):**
- [ ] Điện thoại dọc: danh sách 1–2 cột, bấm mở trang chi tiết.
- [ ] Xoay ngang (≥ 600dp): chuyển sang 2 cột master-detail, **ghi chú đang chọn được giữ nguyên**.
- [ ] Debug bar đổi `MOBILE` ↔ `TABLET` đúng ngưỡng.
- [ ] Không overflow ở mọi hướng.

### Phase 7 — Thêm/Sửa/Xóa + nhập liệu
**Việc làm:** `note_edit_screen.dart`; hoàn thiện `_addNote`, `_updateNote`, `_deleteNote` (có Hoàn tác); `Dismissible`, `MouseRegion`, phím tắt `Ctrl+N`, `Ctrl+S`.
**Checkpoint:**
- [ ] Mở bàn phím ảo không che ô nhập.
- [ ] Vuốt để xóa, bấm Hoàn tác khôi phục được.
- [ ] Màn hình rộng: form được giới hạn bề rộng, căn giữa.
- [ ] Bật chữ lớn trong cài đặt hệ thống (font scale 1.5) → giao diện vẫn không vỡ.

### Phase 8 — Kiểm thử đa điều kiện & chụp minh chứng
**Tạo/chạy các thiết bị ảo (Android Studio → Device Manager):**
| Thiết bị | Mục đích |
|---|---|
| Pixel 5 (hoặc tương đương) dọc | Trạng thái mobile |
| Pixel 5 ngang | Trạng thái tablet (adaptive) |
| Pixel Tablet / Nexus 10 | Tablet thật sự |
| Resizable (Experimental) hoặc chế độ split-screen | Vùng khả dụng thay đổi |

**Chụp vào `docs/screenshots/` (đặt tên rõ):**
1. `01_phone_portrait_list.png`
2. `02_phone_portrait_detail.png`
3. `03_phone_landscape_master_detail.png`
4. `04_tablet_master_detail.png`
5. `05_split_screen.png` (nếu làm được)
6. `06_large_font.png`

**Checkpoint:** đủ ảnh; debug bar hiển thị rõ thông số trong từng ảnh.

### Phase 9 — Chất lượng & dọn dẹp
- `flutter analyze` → 0 warning.
- `dart format lib test`.
- Xóa code thừa, `print` debug.
- Đặt `kShowDebugBar` về giá trị phù hợp (giữ `true` cho bản demo, hoặc thêm nút bật/tắt).
- Đổi tên hiển thị app: `android/app/src/main/AndroidManifest.xml` → `android:label="Adaptive Notes"`.

### Phase 10 — Xuất APK
```bash
flutter clean
flutter pub get
flutter build apk --release
```
- Kết quả: `build/app/outputs/flutter-apk/app-release.apk`
- Sao chép vào `docs/app-release.apk`.
- (Tùy chọn) bản nhỏ hơn theo kiến trúc: `flutter build apk --split-per-abi`.
- Nếu lỗi build: đọc log, kiểm tra `flutter doctor`, license Android (`flutter doctor --android-licenses`), phiên bản JDK/Gradle; sửa và báo lại nguyên nhân.
- Cài thử trên điện thoại thật: `adb install docs/app-release.apk` và kiểm tra lại các Checkpoint của Phase 6–7.

### Phase 11 — Dàn ý báo cáo
Tạo `docs/report_outline.md` theo mục 6 bên dưới.

---

## 6. Dàn ý báo cáo (Agent điền nội dung vào `docs/report_outline.md`)

1. **Giới thiệu đề tài** — mục tiêu, phạm vi, công nghệ.
2. **Cơ sở lý thuyết**
   - 2.1 Responsive vs Adaptive (bảng so sánh, ví dụ trong chính app).
   - 2.2 `MediaQuery`: dùng để làm gì, các thuộc tính hay dùng (`size`, `orientation`, `textScaler`, `padding`, `viewInsets`).
   - 2.3 `LayoutBuilder` và `BoxConstraints`.
   - 2.4 Breakpoint và cách chọn ngưỡng (tham chiếu Material 3 window size classes).
   - 2.5 Nguyên tắc thiết kế: nhiều kích thước, hướng xoay, chữ lớn, vùng chạm ≥ 48dp, giới hạn bề rộng nội dung, nhập liệu cảm ứng/bàn phím/chuột.
3. **Thiết kế & triển khai** — kiến trúc thư mục, sơ đồ luồng (mục 3), đoạn code `LayoutBuilder` tiêu biểu.
4. **Demo & kết quả** — ảnh chụp từng trạng thái + giải thích bố cục nào được chọn ở điều kiện nào.
5. **Đánh giá** — ưu điểm, hạn chế, hướng phát triển (lưu trữ, tìm kiếm, foldable).
6. **Kết luận.**
7. **Phụ lục** — hướng dẫn build APK, link/đường dẫn file.

---

## 7. Điểm lý thuyết cần được thể hiện rõ trong code (để đưa vào báo cáo)

| Khái niệm | Vị trí trong code | Ghi chú giải thích |
|---|---|---|
| Adaptive | `home_screen.dart` | Đổi hẳn `MobileLayout` ↔ `TabletLayout` |
| Responsive | `note_list.dart`, `note_card.dart` | Số cột lưới và co giãn nội dung theo bề rộng |
| `LayoutBuilder` | `home_screen.dart`, `note_list.dart` | Lấy **bề rộng mà widget cha cấp cho nó**, nên đúng cả khi split-screen hoặc khi widget nằm trong pane nhỏ |
| `MediaQuery` | `note_detail_view.dart`, `layout_debug_bar.dart`, `responsive_helper.dart` | Lấy thông tin **toàn màn hình**: orientation, cỡ chữ hệ thống, chiều cao |
| Breakpoint | `breakpoints.dart` | Một nguồn duy nhất cho mọi ngưỡng |
| Nhập liệu | `note_card.dart`, `note_edit_screen.dart`, `home_screen.dart` | Chạm, vuốt, bàn phím ảo, hover, phím tắt |

**Quy tắc chọn:** dùng `LayoutBuilder` khi quyết định bố cục dựa trên *không gian thực tế của một vùng*; dùng `MediaQuery` khi cần thông tin *toàn cục của thiết bị/hệ thống*.

---

## 8. Tiêu chí hoàn thành (Definition of Done)

- [ ] `flutter analyze` không lỗi, không warning.
- [ ] `flutter test` pass (ít nhất test breakpoint và gridColumns).
- [ ] Ít nhất **2 bố cục khác nhau** chuyển đổi đúng theo `LayoutBuilder` + breakpoint.
- [ ] Xoay màn hình không mất dữ liệu hoặc ghi chú đang chọn.
- [ ] Không có overflow ở: dọc, ngang, tablet, chữ lớn 1.5×.
- [ ] Có thêm/sửa/xóa (+ hoàn tác), vuốt xóa hoạt động.
- [ ] Debug bar hiển thị đúng thông số.
- [ ] Có file `app-release.apk` cài và chạy được trên máy thật hoặc emulator.
- [ ] Có đủ ảnh minh chứng và `docs/report_outline.md`.

---

## 9. Quy tắc làm việc dành cho Agent

1. Làm **tuần tự theo Phase**, không nhảy cóc. Sau mỗi Phase tóm tắt ngắn: đã làm gì, file nào đã tạo/sửa, kết quả kiểm tra.
2. Nếu gặp điểm **không rõ hoặc cần quyết định lớn** (ví dụ thêm package, đổi kiến trúc) → **hỏi người dùng trước**, đừng tự quyết.
3. Không thêm tính năng ngoài phạm vi (đăng nhập, cloud, database…).
4. Khi sửa lỗi, nêu rõ **nguyên nhân gốc** và cách sửa, không chỉ che lỗi.
5. Giữ code **ngắn gọn, dễ đọc, dễ giải thích** — đây là bài học thuật, ưu tiên rõ ràng hơn là "thông minh".
6. Cuối cùng, báo cáo tổng kết gồm: cây thư mục cuối, danh sách file, kết quả các checklist ở mục 8, đường dẫn APK.

---

## 10. Prompt khởi động gợi ý (dán vào Agent)

> Hãy đọc `plan.md` trong thư mục dự án. Bắt đầu từ **Phase 1**, thực hiện tuần tự, chạy `flutter analyze` sau mỗi Phase và báo cáo kết quả ngắn gọn trước khi sang Phase tiếp theo. Nếu cần quyết định ngoài phạm vi kế hoạch, hãy hỏi tôi.
