import 'package:flutter/material.dart';

import '../models/todo.dart';

/// Alt gezinme: Tüm Görevler / Devam Edenler / Tamamlananlar.
class StatusNavBar extends StatelessWidget {
  const StatusNavBar({super.key, required this.selected, required this.onChanged});

  final TodoStatus? selected;
  final ValueChanged<TodoStatus?> onChanged;

  static const _statuses = <TodoStatus?>[
    null,
    TodoStatus.inProgress,
    TodoStatus.completed,
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _statuses.indexOf(selected),
      onDestinationSelected: (i) => onChanged(_statuses[i]),
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.format_list_bulleted), label: 'Tüm Görevler'),
        NavigationDestination(
            icon: Icon(Icons.pending_actions), label: 'Devam Edenler'),
        NavigationDestination(
            icon: Icon(Icons.task_alt), label: 'Tamamlananlar'),
      ],
    );
  }
}
