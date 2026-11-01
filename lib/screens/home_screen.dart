import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/sample_notes.dart';
import '../layouts/mobile_layout.dart';
import '../layouts/tablet_layout.dart';
import '../models/note.dart';
import '../utils/breakpoints.dart';
import '../widgets/layout_debug_bar.dart';
import 'note_detail_screen.dart';
import 'note_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State nằm trên LayoutBuilder nên đổi bố cục không tạo lại danh sách.
  final List<Note> _notes = createSampleNotes();
  String? _selectedId;
  bool _showDetail = false;
  bool _showDebug = true;
  bool _editing = false;

  Note? get _selected {
    for (final note in _notes) {
      if (note.id == _selectedId) return note;
    }
    return null;
  }

  void _open(Note note) => setState(() {
    _selectedId = note.id;
    _showDetail = true;
  });

  Future<void> _edit([Note? note]) async {
    if (_editing) return;
    _editing = true;
    final result = await Navigator.of(
      context,
    ).push<Note>(MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)));
    _editing = false;
    if (!mounted || result == null) return;
    setState(() {
      final index = _notes.indexWhere((item) => item.id == result.id);
      if (index < 0) {
        _notes.insert(0, result);
      } else {
        _notes[index] = result;
      }
      _selectedId = result.id;
      _showDetail = true;
    });
  }

  void _delete(Note note) {
    final index = _notes.indexWhere((item) => item.id == note.id);
    if (index < 0) return;
    final wasSelected = _selectedId == note.id;
    final wasDetail = _showDetail;
    setState(() {
      _notes.removeAt(index);
      if (wasSelected) {
        _selectedId = null;
        _showDetail = false;
      }
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã xóa “${note.title}”'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            if (!mounted) return;
            setState(() {
              _notes.insert(index.clamp(0, _notes.length), note);
              if (wasSelected && _selectedId == null) {
                _selectedId = note.id;
                _showDetail = wasDetail;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      // Dựa vào không gian cha cấp, không suy đoán loại máy hoặc chỉ dựa hướng xoay.
      final type = Breakpoints.fromWidth(constraints.maxWidth);
      final selected = _selected;
      final detailVisible =
          type == ScreenType.mobile && _showDetail && selected != null;
      return PopScope(
        canPop: !detailVisible,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && detailVisible) setState(() => _showDetail = false);
        },
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
                _edit(),
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Adaptive Notes'),
                actions: [
                  IconButton(
                    tooltip: 'Bật/tắt thông số bố cục',
                    onPressed: () => setState(() => _showDebug = !_showDebug),
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    if (_showDebug)
                      LayoutDebugBar(width: constraints.maxWidth, type: type),
                    Expanded(
                      child: type == ScreenType.tablet
                          ? TabletLayout(
                              notes: _notes,
                              selected: selected,
                              onOpen: _open,
                              onDelete: _delete,
                              onEdit: _edit,
                            )
                          : detailVisible
                          ? NoteDetailScreen(
                              note: selected,
                              onBack: () => setState(() => _showDetail = false),
                              onEdit: () => _edit(selected),
                              onDelete: () => _delete(selected),
                            )
                          : MobileLayout(
                              notes: _notes,
                              selectedId: _selectedId,
                              onOpen: _open,
                              onDelete: _delete,
                            ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                tooltip: 'Thêm ghi chú (Ctrl+N)',
                onPressed: () => _edit(),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      );
    },
  );
}
