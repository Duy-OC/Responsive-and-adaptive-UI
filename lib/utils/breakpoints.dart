/// Loại bố cục tương ứng với không gian hiển thị hiện tại.
enum ScreenType { mobile, tablet }

/// Nguồn duy nhất chứa các ngưỡng (breakpoint) của ứng dụng.
///
/// Không hardcode ngưỡng ở các widget khác; mọi nơi đều tham chiếu tới đây để
/// khi cần điều chỉnh chỉ phải sửa một chỗ.
class Breakpoints {
  Breakpoints._();

  /// Từ ngưỡng này trở lên dùng bố cục 2 cột (master-detail).
  ///
  /// Chọn 600 vì Material 3 xếp cửa sổ có chiều rộng nhỏ hơn 600dp vào nhóm
  /// compact (điện thoại dọc); từ 600dp trở lên đã đủ chỗ cho hai vùng nội dung
  /// cạnh nhau.
  static const double tablet = 600;

  /// Ngưỡng phụ: màn hình rất rộng, tăng số cột lưới / mở rộng panel.
  ///
  /// 900dp tương ứng nhóm expanded trong Material 3.
  static const double wide = 900;

  /// Chọn bố cục dựa trên chiều rộng khả dụng.
  static ScreenType fromWidth(double width) =>
      width >= tablet ? ScreenType.tablet : ScreenType.mobile;
}
