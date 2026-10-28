import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/todo.dart';
import 'date_time_field.dart';
import 'priority_chip.dart';

/// Kart görünümlü todo satırı; kaydırarak silinir.
class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final done = todo.completed;
    final muted = done ? AppColors.onSurfaceVariant.withValues(alpha: 0.7) : null;
    final hasDesc = todo.description?.isNotEmpty ?? false;

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Material(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        shadowColor: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoundedCheck(checked: done, onTap: onToggle),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              todo.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: muted,
                                decoration:
                                    done ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          PriorityChip(priority: todo.priority),
                        ],
                      ),
                      if (hasDesc) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: muted ?? AppColors.onSurfaceVariant),
                        ),
                      ],
                      if (todo.startsAt != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.schedule,
                                size: 16,
                                color: done
                                    ? muted
                                    : AppColors.primaryContainer),
                            const SizedBox(width: 4),
                            Text(formatDateTime(todo.startsAt!),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: muted ?? AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundedCheck extends StatelessWidget {
  const _RoundedCheck({required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: checked
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: checked
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
