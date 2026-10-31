import 'package:adaptive_notes/data/sample_notes.dart';
import 'package:adaptive_notes/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Note', () {
    test('preview giữ nguyên nội dung ngắn', () {
      final note = Note(
        id: '1',
        title: 'Tiêu đề',
        content: 'Nội dung ngắn',
        color: Colors.white,
        updatedAt: DateTime(2026),
      );

      expect(note.preview, 'Nội dung ngắn');
    });

    test('preview cắt ở 100 ký tự và thêm dấu ba chấm', () {
      final note = Note(
        id: '1',
        title: 'Tiêu đề',
        content: 'a' * 120,
        color: Colors.white,
        updatedAt: DateTime(2026),
      );

      expect(note.preview.length, 101);
      expect(note.preview, '${'a' * 100}…');
    });

    test('copyWith chỉ thay đổi trường được truyền', () {
      final note = Note(
        id: '1',
        title: 'Cũ',
        content: 'Nội dung',
        color: Colors.white,
        updatedAt: DateTime(2026, 1, 1),
      );

      final updated = note.copyWith(title: 'Mới');

      expect(updated.title, 'Mới');
      expect(updated.id, note.id);
      expect(updated.content, note.content);
      expect(updated.color, note.color);
      expect(updated.updatedAt, note.updatedAt);
      expect(note.title, 'Cũ');
    });
  });

  group('sampleNotes', () {
    test('có đúng 10 ghi chú và id duy nhất', () {
      expect(sampleNotes, hasLength(10));
      expect(sampleNotes.map((note) => note.id).toSet(), hasLength(10));
    });

    test('createSampleNotes trả về bản sao độc lập', () {
      final notes = createSampleNotes();
      notes.removeLast();

      expect(notes, hasLength(9));
      expect(sampleNotes, hasLength(10));
    });
  });
}
