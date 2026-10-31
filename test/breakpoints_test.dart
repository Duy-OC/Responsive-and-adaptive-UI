import 'package:adaptive_notes/utils/breakpoints.dart';
import 'package:adaptive_notes/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Breakpoints.fromWidth', () {
    test('599dp vẫn là mobile', () {
      expect(Breakpoints.fromWidth(599), ScreenType.mobile);
    });

    test('600dp chuyển sang tablet', () {
      expect(Breakpoints.fromWidth(600), ScreenType.tablet);
    });

    test('900dp vẫn là tablet', () {
      expect(Breakpoints.fromWidth(900), ScreenType.tablet);
    });
  });

  group('gridColumns', () {
    test('dưới 360dp dùng 1 cột', () {
      expect(gridColumns(359), 1);
      expect(gridColumns(320), 1);
    });

    test('từ 360 đến 899dp dùng 2 cột', () {
      expect(gridColumns(360), 2);
      expect(gridColumns(599), 2);
      expect(gridColumns(600), 2);
      expect(gridColumns(899), 2);
    });

    test('từ 900dp dùng 3 cột', () {
      expect(gridColumns(900), 3);
      expect(gridColumns(1200), 3);
    });
  });

  group('horizontalPadding', () {
    test('tăng theo breakpoint', () {
      expect(horizontalPadding(320), 12);
      expect(horizontalPadding(600), 16);
      expect(horizontalPadding(900), 24);
    });
  });

  group('textScaleClamp', () {
    testWidgets('giới hạn hệ số phóng chữ ở 1.3', (tester) async {
      late double scale;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: Builder(
            builder: (context) {
              scale = textScaleClamp(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(scale, 1.3);
    });
  });
}
