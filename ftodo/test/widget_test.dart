import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ftodo/models/todo.dart';
import 'package:ftodo/widgets/priority_chip.dart';

void main() {
  testWidgets('PriorityChip etiketi gösterir', (tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: PriorityChip(priority: Priority.high)),
      ),
    ));
    expect(find.text('Yüksek'), findsOneWidget);
  });

  test('TodoPayload null alanları temizleme dışında göndermez', () {
    expect(const TodoPayload(completed: true).toJson(), {'completed': true});
    expect(const TodoPayload(clearDescription: true).toJson(),
        {'description': null});
  });
}
