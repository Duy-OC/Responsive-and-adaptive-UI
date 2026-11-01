import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Số cột lưới dựa trên chiều rộng của **chính vùng chứa danh sách**.
///
/// Tham số là chiều rộng do LayoutBuilder cấp, không phải chiều rộng màn hình.
/// Nhờ vậy khi danh sách nằm trong pane nhỏ của tablet hoặc ở chế độ chia đôi
/// màn hình, số cột vẫn được tính đúng.
int gridColumns(double availableWidth) =>
    ResponsiveHelper.gridColumns(availableWidth);

/// Khoảng đệm ngang theo mức rộng của vùng hiển thị.
///
/// Màn hình càng rộng càng cần đệm lớn hơn để nội dung không dính sát mép.
double horizontalPadding(double width) =>
    ResponsiveHelper.horizontalPadding(width);

/// Đọc hệ số phóng chữ hệ thống và giới hạn tối đa 1.3.
///
/// MediaQuery cung cấp thông tin toàn cục của thiết bị. Người dùng có thể bật
/// chữ rất lớn trong cài đặt hệ thống; giới hạn lại giúp bố cục không bị vỡ
/// trong khi vẫn tôn trọng nhu cầu tăng cỡ chữ.
double textScaleClamp(BuildContext context) =>
    ResponsiveHelper.textScaleClamp(context);

/// Nhóm hàm tiện ích dùng chung cho các widget responsive.
class ResponsiveHelper {
  ResponsiveHelper._();

  /// `< 360` → 1 cột; `360–899` → 2 cột; `>= 900` → 3 cột.
  static int gridColumns(double availableWidth) {
    if (availableWidth >= Breakpoints.wide) {
      return 3;
    }
    if (availableWidth >= 360) {
      return 2;
    }
    return 1;
  }

  /// 12dp cho mobile, 16dp cho tablet, 24dp cho màn hình rất rộng.
  static double horizontalPadding(double width) {
    if (width >= Breakpoints.wide) {
      return 24;
    }
    if (width >= Breakpoints.tablet) {
      return 16;
    }
    return 12;
  }

  /// Giới hạn hệ số phóng chữ trong khoảng 0.0–1.3.
  static double textScaleClamp(BuildContext context) {
    final TextScaler textScaler = MediaQuery.textScalerOf(context);
    final double scale = textScaler.scale(1);
    return scale.clamp(0.0, 1.3);
  }
}
