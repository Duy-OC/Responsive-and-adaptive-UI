// Kiểm tra thuần Dart, không cần Flutter engine hay kết nối mạng.
import 'dart:io';

import 'package:adaptive_notes/utils/breakpoints.dart';
import 'package:adaptive_notes/utils/responsive_helper.dart';

void main() {
  var checks = 0;
  void check(bool condition, String message) {
    if (!condition) throw StateError(message);
    checks++;
  }

  check(Breakpoints.fromWidth(599) == ScreenType.mobile, '599 mobile');
  check(Breakpoints.fromWidth(600) == ScreenType.tablet, '600 tablet');
  check(Breakpoints.fromWidth(900) == ScreenType.tablet, '900 tablet');
  check(gridColumns(320) == 1, '320 one column');
  check(gridColumns(399) == 1, '399 one column');
  check(gridColumns(400) == 2, '400 two columns');
  check(gridColumns(899) == 2, '899 two columns');
  check(gridColumns(900) == 3, '900 three columns');
  check(horizontalPadding(320) == 12, 'mobile padding');
  check(horizontalPadding(600) == 16, 'tablet padding');
  check(horizontalPadding(900) == 24, 'wide padding');
  // Pane tablet 600dp × 40% sau trừ padding vẫn chỉ được dùng 1 cột.
  final paneWidth = (600 - 1) * 2 / 5;
  check(
    gridColumns(paneWidth - horizontalPadding(paneWidth) * 2) == 1,
    'narrow tablet pane',
  );
  stdout.writeln('PASS: $checks layout rule checks.');
}
