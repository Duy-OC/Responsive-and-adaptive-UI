import 'package:flutter/material.dart';

import '../models/note.dart';
import '../widgets/note_detail_view.dart';

/// Nhúng trong HomeScreen để việc đổi layout không để lại route chi tiết cũ.
class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({
    super.key,
    required this.note,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });
  final Note note;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Danh sách'),
        ),
      ),
      Expanded(
        child: NoteDetailView(note: note, onEdit: onEdit, onDelete: onDelete),
      ),
    ],
  );
}
