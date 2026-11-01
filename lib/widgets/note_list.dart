import 'package:flutter/material.dart';

import '../models/note.dart';
import '../utils/responsive_helper.dart';
import 'empty_state.dart';
import 'note_card.dart';

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
    required this.selectedId,
    required this.onOpen,
    required this.onDelete,
  });
  final List<Note> notes;
  final String? selectedId;
  final ValueChanged<Note> onOpen;
  final ValueChanged<Note> onDelete;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const EmptyState(
        message: 'Chưa có ghi chú nào. Bấm + để tạo mới.',
      );
    }
    // Đo riêng vùng danh sách: trên tablet vùng này nhỏ hơn toàn cửa sổ.
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = horizontalPadding(constraints.maxWidth);
        final scaler = MediaQuery.textScalerOf(context);
        final columns = gridColumns(constraints.maxWidth - padding * 2);
        return GridView.builder(
          key: const PageStorageKey('notes-grid'),
          padding: EdgeInsets.fromLTRB(padding, 16, padding, 96),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            // Chiều cao tăng theo cỡ chữ hệ thống, không ép nhỏ chữ của người dùng.
            mainAxisExtent: 100 + scaler.scale(17) * 3 + scaler.scale(14) * 6,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Dismissible(
              key: ValueKey(note.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Theme.of(context).colorScheme.errorContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.delete_outline),
              ),
              onDismissed: (_) => onDelete(note),
              child: NoteCard(
                note: note,
                selected: selectedId == note.id,
                onOpen: () => onOpen(note),
                onDelete: () => onDelete(note),
              ),
            );
          },
        );
      },
    );
  }
}
