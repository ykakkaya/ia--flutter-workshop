import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/todo.dart';

/// Tasarımdaki pill rozet: yüksek = kırmızı, normal = mor, düşük = gri.
class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});

  final Priority priority;

  (Color, Color) get _colors => switch (priority) {
        Priority.high => (AppColors.errorContainer, AppColors.onErrorContainer),
        Priority.normal =>
          (AppColors.secondaryFixed, AppColors.onSecondaryFixedVariant),
        Priority.low =>
          (AppColors.surfaceContainerHigh, AppColors.onSurfaceVariant),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(priority.label,
          style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}
