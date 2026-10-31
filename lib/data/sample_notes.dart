import 'package:flutter/material.dart';

import '../models/note.dart';

/// Bảng màu pastel dùng chung cho các ghi chú mẫu.
///
/// Giữ số lượng màu nhỏ (6 màu) để giao diện hài hòa và dễ phân biệt.
const List<Color> notePastelColors = <Color>[
  Color(0xFFFFF3CD), // vàng nhạt
  Color(0xFFD1E7DD), // xanh lá nhạt
  Color(0xFFCFE2FF), // xanh dương nhạt
  Color(0xFFF8D7DA), // hồng nhạt
  Color(0xFFE2D9F3), // tím nhạt
  Color(0xFFFFE5D9), // cam nhạt
];

/// 10 ghi chú mẫu bằng tiếng Việt.
///
/// Nội dung cố tình có độ dài khác nhau (một dòng, vài dòng, nhiều đoạn) để
/// kiểm tra khả năng co giãn và cuộn của giao diện.
final List<Note> sampleNotes = <Note>[
  Note(
    id: 'note-01',
    title: 'Lịch học tuần này',
    content:
        'Thứ 2: Lập trình di động (7:30 - 9:30).\n'
        'Thứ 3: Cơ sở dữ liệu (9:30 - 11:30).\n'
        'Thứ 5: Làm bài tập nhóm môn Thiết kế giao diện.\n'
        'Thứ 7: Ôn tập Responsive và Adaptive UI.',
    color: notePastelColors[0],
    updatedAt: DateTime(2026, 10, 26, 8, 15),
  ),
  Note(
    id: 'note-02',
    title: 'Danh sách đi chợ',
    content: 'Sữa tươi, trứng gà, rau cải, cà chua, gạo và một ít trái cây.',
    color: notePastelColors[1],
    updatedAt: DateTime(2026, 10, 25, 17, 40),
  ),
  Note(
    id: 'note-03',
    title: 'Ý tưởng ứng dụng ghi chú',
    content:
        'Xây dựng ứng dụng ghi chú có giao diện thay đổi theo kích thước màn hình.\n\n'
        'Trên điện thoại dọc: hiển thị danh sách dạng lưới, chạm vào một ghi chú '
        'để mở màn hình chi tiết.\n'
        'Trên điện thoại ngang hoặc máy tính bảng: chia màn hình thành hai vùng, '
        'bên trái là danh sách và bên phải là nội dung ghi chú đang chọn.\n\n'
        'Điểm cần chú ý: giữ nguyên dữ liệu và ghi chú đang chọn khi xoay màn hình.',
    color: notePastelColors[2],
    updatedAt: DateTime(2026, 10, 24, 21, 5),
  ),
  Note(
    id: 'note-04',
    title: 'Hẹn khám sức khỏe',
    content: 'Thứ 4 lúc 15:00 tại phòng khám gần nhà. Nhớ mang theo sổ khám bệnh.',
    color: notePastelColors[3],
    updatedAt: DateTime(2026, 10, 23, 10, 30),
  ),
  Note(
    id: 'note-05',
    title: 'Bài tập Flutter',
    content:
        'Hoàn thiện màn hình HomeScreen với LayoutBuilder.\n'
        'Kiểm tra breakpoint 600dp: dưới ngưỡng dùng MobileLayout, từ ngưỡng trở '
        'lên dùng TabletLayout.\n'
        'Viết unit test cho Breakpoints.fromWidth và hàm gridColumns.\n'
        'Chạy flutter analyze và flutter test trước khi nộp bài.',
    color: notePastelColors[4],
    updatedAt: DateTime(2026, 10, 22, 20, 0),
  ),
  Note(
    id: 'note-06',
    title: 'Mua quà sinh nhật',
    content:
        'Mẹ thích đọc sách và uống trà. Có thể chọn một cuốn sách về nấu ăn, '
        'một hộp trà thơm và một tấm thiệp viết tay.',
    color: notePastelColors[5],
    updatedAt: DateTime(2026, 10, 21, 9, 45),
  ),
  Note(
    id: 'note-07',
    title: 'Kế hoạch cuối tuần',
    content:
        'Sáng thứ 7: dọn phòng và giặt quần áo.\n'
        'Chiều thứ 7: đi cà phê với nhóm bạn.\n'
        'Chủ nhật: nghỉ ngơi, chuẩn bị bài cho tuần mới.',
    color: notePastelColors[0],
    updatedAt: DateTime(2026, 10, 20, 18, 20),
  ),
  Note(
    id: 'note-08',
    title: 'Mật khẩu wifi nhà',
    content: 'Tên mạng: NhaToi_5G. Mật khẩu: 12345678.',
    color: notePastelColors[1],
    updatedAt: DateTime(2026, 10, 19, 14, 10),
  ),
  Note(
    id: 'note-09',
    title: 'Ghi chú cuộc họp nhóm',
    content:
        'Thống nhất chia công việc:\n'
        '- Bạn A: viết model Note và dữ liệu mẫu.\n'
        '- Bạn B: làm breakpoint và các hàm responsive.\n'
        '- Bạn C: dựng hai layout mobile/tablet.\n'
        '- Bạn D: kiểm thử trên nhiều kích thước màn hình và chụp ảnh minh chứng.\n\n'
        'Hạn nộp báo cáo: cuối tuần sau. Mọi người nhớ cập nhật tiến độ trong nhóm chat.',
    color: notePastelColors[2],
    updatedAt: DateTime(2026, 10, 18, 16, 55),
  ),
  Note(
    id: 'note-10',
    title: 'Nhắc nhở bản thân',
    content:
        'Uống đủ nước, ngủ đủ giấc và dành ít nhất 30 phút mỗi ngày để vận động. '
        'Khi làm bài tập lớn nên chia nhỏ công việc thay vì dồn vào phút cuối.',
    color: notePastelColors[3],
    updatedAt: DateTime(2026, 10, 17, 7, 25),
  ),
];

/// Trả về bản sao có thể chỉnh sửa của danh sách mẫu.
///
/// HomeScreen cần một danh sách riêng để thêm/xóa ghi chú mà không làm thay
/// đổi dữ liệu mẫu gốc.
List<Note> createSampleNotes() => List<Note>.of(sampleNotes);
