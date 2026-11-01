import 'package:flutter/material.dart';

import '../models/note.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_detail_view.dart';
import '../widgets/note_list.dart';

class TabletLayout extends StatelessWidget {
  const TabletLayout({
    super.key,
    required this.notes,
    required this.selected,
    required this.onOpen,
    required this.onDelete,
    required this.onEdit,
  });
  final List<Note> notes;
  final Note? selected;
  final ValueChanged<Note> onOpen;
  final ValueChanged<Note> onDelete;
  final ValueChanged<Note> onEdit;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        flex: 2,
        child: NoteList(
          notes: notes,
          selectedId: selected?.id,
          onOpen: onOpen,
          onDelete: onDelete,
        ),
      ),
      const VerticalDivider(width: 1),
      Expanded(
        flex: 3,
        child: selected == null
            ? const EmptyState(message: 'Chọn một ghi chú để xem')
            : NoteDetailView(
                note: selected!,
                onEdit: () => onEdit(selected!),
                onDelete: () => onDelete(selected!),
              ),
      ),
    ],
  );
}
