import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/date_time_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/priority_selector.dart';
import '../widgets/snackbars.dart';

/// [todo] verilirse düzenleme, verilmezse oluşturma modunda çalışır.
class TodoFormScreen extends ConsumerStatefulWidget {
  const TodoFormScreen({super.key, this.todo});

  final Todo? todo;

  @override
  ConsumerState<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends ConsumerState<TodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.todo?.title);
  late final _description =
      TextEditingController(text: widget.todo?.description);
  late Priority _priority = widget.todo?.priority ?? Priority.normal;
  late DateTime? _startsAt = widget.todo?.startsAt;
  late bool _completed = widget.todo?.completed ?? false;
  bool _loading = false;

  bool get _isEdit => widget.todo != null;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final desc = _description.text.trim();
    final payload = TodoPayload(
      title: _title.text.trim(),
      description: desc.isEmpty ? null : desc,
      clearDescription: desc.isEmpty,
      priority: _priority,
      startsAt: _startsAt,
      clearStartsAt: _startsAt == null,
      completed: _completed,
    );
    try {
      final notifier = ref.read(todosProvider.notifier);
      if (_isEdit) {
        await notifier.edit(widget.todo!.id, payload);
      } else {
        await notifier.add(payload);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        showErrorSnack(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Todo Düzenle' : 'Yeni Todo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              AppTextField(
                controller: _title,
                label: 'Başlık',
                maxLength: 255,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Başlık gerekli' : null,
              ),
              AppTextField(
                controller: _description,
                label: 'Açıklama',
                maxLines: 4,
                maxLength: 5000,
              ),
              PrioritySelector(
                value: _priority,
                onChanged: (p) => setState(() => _priority = p),
              ),
              DateTimeField(
                label: 'Başlangıç',
                value: _startsAt,
                onChanged: (d) => setState(() => _startsAt = d),
              ),
              SwitchListTile(
                title: const Text('Tamamlandı'),
                value: _completed,
                onChanged: (v) => setState(() => _completed = v),
              ),
              PrimaryButton(
                label: _isEdit ? 'Kaydet' : 'Oluştur',
                loading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
