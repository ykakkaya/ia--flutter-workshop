import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../models/todo.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/async_value_view.dart';
import '../widgets/empty_state.dart';
import '../widgets/progress_summary_card.dart';
import '../widgets/snackbars.dart';
import '../widgets/status_nav_bar.dart';
import '../widgets/todo_tile.dart';
import 'todo_form_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _titles = {
    null: 'Tüm Görevler',
    TodoStatus.inProgress: 'Devam Edenler',
    TodoStatus.completed: 'Tamamlananlar',
  };

  void _openForm(BuildContext context, [Todo? todo]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TodoFormScreen(todo: todo)),
    );
  }

  Future<void> _run(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) showErrorSnack(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    final filter = ref.watch(statusFilterProvider);
    final user = ref.watch(authProvider).value;
    final notifier = ref.read(todosProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user == null ? 'Tekrar hoşgeldin' : 'Merhaba, ${user.name}',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurfaceVariant),
            ),
            Text(_titles[filter]!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          PopupMenuButton<void>(
            tooltip: 'Hesap',
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => ref.read(authProvider.notifier).logout(),
                child: const Row(children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 12),
                  Text('Çıkış yap'),
                ]),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Color(0x594F46E5), blurRadius: 24, offset: Offset(0, 8)),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () => _openForm(context),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
      bottomNavigationBar: StatusNavBar(
        selected: filter,
        onChanged: ref.read(statusFilterProvider.notifier).set,
      ),
      body: AsyncValueView<List<Todo>>(
        value: todos,
        onRetry: () => ref.invalidate(todosProvider),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(todosProvider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            children: [
              // İlerleme yalnızca tüm liste yüklüyken anlamlı.
              if (filter == null && list.isNotEmpty) ...[
                ProgressSummaryCard(
                  done: list.where((t) => t.completed).length,
                  total: list.length,
                ),
                const SizedBox(height: 16),
              ],
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 96),
                  child: EmptyState(message: 'Henüz görev yok'),
                )
              else
                for (final todo in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TodoTile(
                      todo: todo,
                      onTap: () => _openForm(context, todo),
                      onToggle: () => _run(context, () => notifier.toggle(todo)),
                      onDelete: () =>
                          _run(context, () => notifier.remove(todo.id)),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
