import 'package:flutter/material.dart';

import '../models/note.dart';
import 'note_card.dart';

class NoteDetailView extends StatelessWidget {
  const NoteDetailView({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    return SingleChildScrollView(
      key: ValueKey('detail-${note.id}'),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: landscape ? 12 : 24,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: landscape
                    ? Theme.of(context).textTheme.headlineSmall
                    : Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text('Cập nhật: ${formatNoteDate(note.updatedAt)}'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Sửa'),
                  ),
                  OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Xóa'),
                  ),
                ],
              ),
              const Divider(height: 32),
              SelectableText(note.content),
            ],
          ),
        ),
      ),
    );
  }
}
