import 'breakpoints.dart';

/// Bề rộng này đã trừ padding, thuộc riêng vùng chứa danh sách.
int gridColumns(double availableWidth) {
  if (availableWidth >= Breakpoints.gridThreeColumns) return 3;
  if (availableWidth >= Breakpoints.gridTwoColumns) return 2;
  return 1;
}

double horizontalPadding(double width) {
  if (width >= Breakpoints.wide) return 24;
  if (width >= Breakpoints.tablet) return 16;
  return 12;
}
