import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus_social_club/main.dart';

void main() {
  testWidgets('Intro starts on welcome step', (WidgetTester tester) async {
    await tester.pumpWidget(const FocusApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Phone validation blocks progress when invalid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('GET STARTED'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid phone number'), findsOneWidget);
    expect(find.text('SMS Code'), findsNothing);
  });

  testWidgets('Valid phone advances to SMS screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '2345678910');
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('SMS Code'), findsOneWidget);
    expect(find.text('Code'), findsOneWidget);
    expect(find.text('Change number'), findsOneWidget);
  });

  testWidgets('Entering six-digit code auto-advances to all set', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '2345678910');
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pumpAndSettle();

    expect(find.text('All set!'), findsOneWidget);
    expect(find.text('Finish'), findsOneWidget);
  });

  testWidgets('Change number returns to phone entry step', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '2345678910');
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change number'));
    await tester.pumpAndSettle();

    expect(find.text('GET STARTED'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
  });

  testWidgets('Finish navigates to employers screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FocusApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '2345678910');
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();

    expect(find.text('My Employers'), findsOneWidget);
    expect(find.text('Create New Venue'), findsOneWidget);
    expect(find.text('Join Existing Venue'), findsOneWidget);
  });
}
