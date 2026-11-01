import 'package:adaptive_notes/utils/breakpoints.dart';
import 'package:adaptive_notes/utils/responsive_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Chuyển bố cục đúng tại 600dp', () {
    expect(Breakpoints.fromWidth(599), ScreenType.mobile);
    expect(Breakpoints.fromWidth(600), ScreenType.tablet);
    expect(Breakpoints.fromWidth(900), ScreenType.tablet);
  });
  test('Lưới dùng bề rộng nội dung của vùng danh sách', () {
    expect(gridColumns(320), 1);
    expect(gridColumns(399), 1);
    expect(gridColumns(400), 2);
    expect(gridColumns(899), 2);
    expect(gridColumns(900), 3);
  });
  test('Khoảng đệm tăng theo bề rộng', () {
    expect(horizontalPadding(320), 12);
    expect(horizontalPadding(600), 16);
    expect(horizontalPadding(900), 24);
  });
}
