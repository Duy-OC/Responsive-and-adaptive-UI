import 'package:flutter/material.dart';

import '../models/note.dart';
import '../widgets/note_list.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({
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
  Widget build(BuildContext context) => NoteList(
    notes: notes,
    selectedId: selectedId,
    onOpen: onOpen,
    onDelete: onDelete,
  );
}
