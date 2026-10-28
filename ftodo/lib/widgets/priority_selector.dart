import 'package:flutter/material.dart';

import '../models/todo.dart';

class PrioritySelector extends StatelessWidget {
  const PrioritySelector({super.key, required this.value, required this.onChanged});

  final Priority value;
  final ValueChanged<Priority> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Priority>(
      segments: [
        for (final p in Priority.values)
          ButtonSegment(value: p, label: Text(p.label)),
      ],
      selected: {value},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
