import 'package:adaptive_notes/main.dart';
import 'package:adaptive_notes/screens/home_screen.dart';
import 'package:adaptive_notes/layouts/mobile_layout.dart';
import 'package:adaptive_notes/layouts/tablet_layout.dart';
import 'package:adaptive_notes/screens/note_detail_screen.dart';
import 'package:adaptive_notes/widgets/note_card.dart';
import 'package:adaptive_notes/widgets/note_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> resize(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  await tester.pumpAndSettle();
}

void resetView(WidgetTester tester) {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('Chọn ghi chú rồi đổi bố cục vẫn giữ nội dung', (tester) async {
    resetView(tester);
    await resize(tester, const Size(390, 844));
    await tester.pumpWidget(const AdaptiveNotesApp());
    await tester.pumpAndSettle();
    expect(find.byType(MobileLayout), findsOneWidget);
    await tester.tap(find.text('Lịch học tuần này'));
    await tester.pumpAndSettle();
    expect(find.byType(NoteDetailScreen), findsOneWidget);
    await resize(tester, const Size(900, 600));
    expect(find.byType(TabletLayout), findsOneWidget);
    expect(
      tester.widget<NoteDetailView>(find.byType(NoteDetailView)).note.id,
      'note-01',
    );
    await resize(tester, const Size(390, 844));
    expect(find.byType(NoteDetailScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MobileLayout), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Thêm, kiểm tra tiêu đề, sửa, xóa và hoàn tác', (tester) async {
    resetView(tester);
    await resize(tester, const Size(390, 844));
    await tester.pumpWidget(const AdaptiveNotesApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập tiêu đề'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('title-field')),
      'Ghi chú kiểm thử',
    );
    await tester.enterText(
      find.byKey(const ValueKey('content-field')),
      'Nội dung mới',
    );
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Ghi chú kiểm thử'), findsOneWidget);
    await tester.tap(find.text('Sửa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('title-field')), 'Đã sửa');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Đã sửa'), findsOneWidget);
    await tester.tap(find.text('Xóa'));
    await tester.pumpAndSettle();
    expect(find.byType(NoteDetailScreen), findsNothing);
    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(find.text('Đã sửa'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Vuốt xóa và hoàn tác phục hồi thẻ', (tester) async {
    resetView(tester);
    await resize(tester, const Size(390, 844));
    await tester.pumpWidget(const AdaptiveNotesApp());
    await tester.pumpAndSettle();
    await tester.drag(find.byType(NoteCard).first, const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Lịch học tuần này'), findsNothing);
    await tester.tap(find.text('Hoàn tác'));
    await tester.pumpAndSettle();
    expect(find.text('Lịch học tuần này'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ctrl+N và Ctrl+S tạo ghi chú bằng bàn phím', (tester) async {
    resetView(tester);
    await resize(tester, const Size(1000, 800));
    await tester.pumpWidget(const AdaptiveNotesApp());
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('title-field')),
      'Phím tắt',
    );
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.byType(TabletLayout), findsOneWidget);
    expect(
      tester.widget<NoteDetailView>(find.byType(NoteDetailView)).note.title,
      'Phím tắt',
    );
  });

  testWidgets('Không overflow ở kích thước demo, chữ lớn và theme tối', (
    tester,
  ) async {
    resetView(tester);
    for (final size in [
      const Size(320, 640),
      const Size(599, 800),
      const Size(600, 800),
      const Size(844, 390),
      const Size(1280, 800),
    ]) {
      for (final scale in [1.0, 1.5, 2.0]) {
        await resize(tester, size);
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(useMaterial3: true),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const HomeScreen(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$size / $scale');
      }
    }
  });
}
