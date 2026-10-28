import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../models/todo.dart';

/// `null` → tümü.
class StatusFilterNotifier extends Notifier<TodoStatus?> {
  @override
  TodoStatus? build() => null;

  void set(TodoStatus? status) => state = status;
}

final statusFilterProvider =
    NotifierProvider<StatusFilterNotifier, TodoStatus?>(
        StatusFilterNotifier.new);

class TodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() {
    final status = ref.watch(statusFilterProvider);
    return ref.read(todoRepositoryProvider).list(status: status);
  }

  // Mutasyonlar hata fırlatır (UI SnackBar gösterir); başarıda liste yenilenir.
  Future<void> add(TodoPayload payload) async {
    await ref.read(todoRepositoryProvider).create(payload);
    ref.invalidateSelf();
  }

  Future<void> edit(int id, TodoPayload payload) async {
    await ref.read(todoRepositoryProvider).update(id, payload);
    ref.invalidateSelf();
  }

  Future<void> toggle(Todo todo) =>
      edit(todo.id, TodoPayload(completed: !todo.completed));

  Future<void> remove(int id) async {
    await ref.read(todoRepositoryProvider).delete(id);
    ref.invalidateSelf();
  }
}

final todosProvider =
    AsyncNotifierProvider<TodosNotifier, List<Todo>>(TodosNotifier.new);
