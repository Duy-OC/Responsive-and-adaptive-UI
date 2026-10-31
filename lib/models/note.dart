import 'package:flutter/material.dart';

/// Một ghi chú bất biến (immutable).
///
/// Mọi thay đổi đều tạo ra đối tượng mới thông qua [copyWith], nhờ đó state ở
/// HomeScreen có thể cập nhật danh sách mà không sửa trực tiếp dữ liệu cũ.
@immutable
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String content;
  final Color color;
  final DateTime updatedAt;

  /// Nội dung rút gọn dùng trên thẻ ghi chú.
  ///
  /// Chỉ lấy tối đa 100 ký tự đầu; nếu nội dung dài hơn thì thêm dấu "…" để
  /// người đọc biết còn phần phía sau.
  String get preview {
    const maxLength = 100;
    if (content.length <= maxLength) {
      return content;
    }
    return '${content.substring(0, maxLength)}…';
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    Color? color,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Note &&
            other.id == id &&
            other.title == title &&
            other.content == content &&
            other.color == color &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(id, title, content, color, updatedAt);
}
