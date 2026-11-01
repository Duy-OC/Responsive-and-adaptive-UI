enum ScreenType { mobile, tablet }

class Breakpoints {
  Breakpoints._();

  /// Ngưỡng ứng dụng chọn cho bố cục danh sách–chi tiết (đơn vị logical pixel).
  static const double tablet = 600;

  /// Ngưỡng tùy chỉnh tăng khoảng đệm, không phải phân loại thiết bị.
  static const double wide = 900;

  /// Hai thẻ phải đủ rộng để đọc được cả khi danh sách là pane nhỏ.
  static const double gridTwoColumns = 400;
  static const double gridThreeColumns = 900;

  static ScreenType fromWidth(double width) =>
      width >= tablet ? ScreenType.tablet : ScreenType.mobile;
}
