import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/venue_registration/bloc/venue_registration_bloc.dart';
import 'package:focus_social_club/features/venue_registration/screens/venue_registration_screen.dart';

Widget _withVenueRegistrationBloc(Widget child) {
  return BlocProvider<VenueRegistrationBloc>(
    create: (_) => VenueRegistrationBloc(),
    child: child,
  );
}

void main() {
  testWidgets('Next starts disabled and enables when step one is valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _withVenueRegistrationBloc(
        const MaterialApp(home: VenueRegistrationScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Personal Information'), findsOneWidget);
    final nextButtonFinder = find.widgetWithText(ElevatedButton, 'Next');
    expect(nextButtonFinder, findsOneWidget);
    final disabledNext = tester.widget<ElevatedButton>(nextButtonFinder);
    expect(disabledNext.onPressed, isNull);

    await tester.enterText(find.byType(TextField).at(0), 'Jane Doe');
    await tester.enterText(find.byType(TextField).at(1), 'jane@example.com');
    await tester.pumpAndSettle();

    final enabledNext = tester.widget<ElevatedButton>(nextButtonFinder);
    expect(enabledNext.onPressed, isNotNull);
  });

  testWidgets('Venue registration flows across all three steps when valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _withVenueRegistrationBloc(
        const MaterialApp(home: VenueRegistrationScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Jane Doe');
    await tester.enterText(find.byType(TextField).at(1), 'jane@example.com');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Venue Information'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Focus Downtown');
    await tester.enterText(find.byType(TextField).at(1), '500');
    await tester.enterText(find.byType(TextField).at(2), 'USD');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Venue Address'), findsOneWidget);
    expect(find.text('Previous'), findsOneWidget);
  });

  testWidgets('Final next shows completion dialog with required copy', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _withVenueRegistrationBloc(
        const MaterialApp(home: VenueRegistrationScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Jane Doe');
    await tester.enterText(find.byType(TextField).at(1), 'jane@example.com');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Focus Downtown');
    await tester.enterText(find.byType(TextField).at(1), '500');
    await tester.enterText(find.byType(TextField).at(2), 'USD');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), '12 Main Street');
    await tester.enterText(find.byType(TextField).at(2), 'New York');
    await tester.enterText(find.byType(TextField).at(3), 'NY');
    await tester.enterText(find.byType(TextField).at(4), 'USA');
    await tester.enterText(find.byType(TextField).at(5), '10001');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text("You're All Set"), findsOneWidget);
    expect(find.text('Schedule Free Demo'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text("You're All Set"), findsNothing);
  });

  testWidgets('Exit returns to previous route', (WidgetTester tester) async {
    await tester.pumpWidget(
      _withVenueRegistrationBloc(
        MaterialApp(
          initialRoute: '/venue-registration',
          routes: {
            '/': (_) => const Scaffold(body: Text('Previous Screen')),
            '/venue-registration': (_) => const VenueRegistrationScreen(),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Exit'));
    await tester.pumpAndSettle();

    expect(find.text('Previous Screen'), findsOneWidget);
  });
}
