import 'package:flutter/material.dart';

import '../core/theme.dart';

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({super.key, required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : done / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ambientShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Günlük İlerleme',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.onSurfaceVariant)),
                    Text('$total görevin $done\'i tamamlandı',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer.withValues(alpha: 0.1),
                ),
                child: Text('${(ratio * 100).round()}%',
                    style: const TextStyle(
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHighest,
              color: AppColors.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
