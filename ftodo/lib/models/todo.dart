enum Priority {
  low('low', 'Düşük'),
  normal('normal', 'Normal'),
  high('high', 'Yüksek');

  const Priority(this.value, this.label);
  final String value;
  final String label;

  static Priority fromValue(String? v) =>
      Priority.values.firstWhere((p) => p.value == v, orElse: () => normal);
}

enum TodoStatus {
  inProgress('in_progress', 'Devam eden'),
  completed('completed', 'Tamamlanan');

  const TodoStatus(this.value, this.label);
  final String value;
  final String label;
}

class Todo {
  const Todo({
    required this.id,
    required this.title,
    this.description,
    this.priority = Priority.normal,
    this.startsAt,
    this.completed = false,
  });

  final int id;
  final String title;
  final String? description;
  final Priority priority;
  final DateTime? startsAt;
  final bool completed;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String?,
        priority: Priority.fromValue(json['priority'] as String?),
        startsAt: json['starts_at'] == null
            ? null
            : DateTime.parse(json['starts_at'] as String).toLocal(),
        completed: json['completed'] as bool? ?? false,
      );
}

/// Oluşturma/güncelleme gövdesi. `null` alanlar PATCH'te gönderilmez;
/// description/starts_at temizlemek için [clearDescription]/[clearStartsAt].
class TodoPayload {
  const TodoPayload({
    this.title,
    this.description,
    this.priority,
    this.startsAt,
    this.completed,
    this.clearDescription = false,
    this.clearStartsAt = false,
  });

  final String? title;
  final String? description;
  final Priority? priority;
  final DateTime? startsAt;
  final bool? completed;
  final bool clearDescription;
  final bool clearStartsAt;

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null || clearDescription) 'description': description,
        if (priority != null) 'priority': priority!.value,
        if (startsAt != null || clearStartsAt)
          'starts_at': startsAt?.toUtc().toIso8601String(),
        if (completed != null) 'completed': completed,
      };
}
