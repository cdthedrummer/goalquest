import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goalquest/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoalQuestApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}