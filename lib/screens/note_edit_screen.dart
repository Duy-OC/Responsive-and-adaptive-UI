import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/sample_notes.dart';
import '../models/note.dart';

class NoteEditScreen extends StatefulWidget {
  const NoteEditScreen({super.key, this.note});
  final Note? note;

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _content;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note?.title);
    _content = TextEditingController(text: widget.note?.content);
    _color = widget.note?.color ?? notePastelColors.first;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now();
    Navigator.of(context).pop(
      Note(
        id: widget.note?.id ?? 'note-${now.microsecondsSinceEpoch}',
        title: _title.text.trim(),
        content: _content.text.trim(),
        color: _color,
        updatedAt: now,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CallbackShortcuts(
    bindings: {
      const SingleActivator(LogicalKeyboardKey.keyS, control: true): _save,
    },
    child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.note == null ? 'Thêm ghi chú' : 'Sửa ghi chú'),
        actions: [TextButton(onPressed: _save, child: const Text('Lưu'))],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: const ValueKey('title-field'),
                      controller: _title,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Vui lòng nhập tiêu đề'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('content-field'),
                      controller: _content,
                      minLines: 6,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Màu ghi chú'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < notePastelColors.length; i++)
                          ChoiceChip(
                            label: Text('Màu ${i + 1}'),
                            selected: _color == notePastelColors[i],
                            backgroundColor: notePastelColors[i],
                            selectedColor: notePastelColors[i],
                            labelStyle: const TextStyle(
                              color: Color(0xFF202A27),
                            ),
                            checkmarkColor: const Color(0xFF202A27),
                            onSelected: (_) =>
                                setState(() => _color = notePastelColors[i]),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Lưu ghi chú'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
