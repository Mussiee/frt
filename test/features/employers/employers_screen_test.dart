import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/employers/bloc/employers_bloc.dart';
import 'package:focus_social_club/features/employers/screens/employers_screen.dart';
import 'package:focus_social_club/features/venue_welcome/screens/venue_welcome_screen.dart';
import 'package:go_router/go_router.dart';

Widget _withEmployersBloc(Widget child) {
  return BlocProvider<EmployersBloc>(
    create: (_) => EmployersBloc(),
    child: child,
  );
}

GoRouter _routerForEmployersTests() {
  return GoRouter(
    initialLocation: '/employers',
    routes: [
      GoRoute(
        path: '/employers',
        builder: (context, state) => const EmployersScreen(),
      ),
      GoRoute(
        path: '/venue-welcome',
        builder: (context, state) => const VenueWelcomeScreen(),
      ),
      GoRoute(
        path: '/my-account',
        builder: (context, state) => const Scaffold(body: Text('My Account')),
      ),
    ],
  );
}

void main() {
  testWidgets('EmployersScreen renders venues empty state by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _withEmployersBloc(const MaterialApp(home: EmployersScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Employers'), findsOneWidget);
    expect(find.text('Venues'), findsOneWidget);
    expect(find.text('Promoters'), findsOneWidget);
    expect(
      find.text(
        'You currently do not have any venues\nassociated with your account',
      ),
      findsOneWidget,
    );
    expect(find.text('Create New Venue'), findsOneWidget);
    expect(find.text('Join Existing Venue'), findsOneWidget);
  });

  testWidgets('Promoters tab renders promo design empty state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _withEmployersBloc(const MaterialApp(home: EmployersScreen())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Promoters'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'You currently do not have any promo\ncompanies associated with your account',
      ),
      findsOneWidget,
    );
    expect(find.text('Create a Promo Company'), findsOneWidget);
    expect(find.text('Join Promo Company'), findsOneWidget);
  });

  testWidgets('Plus opens venue-aware dialog and cancel closes it', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _withEmployersBloc(const MaterialApp(home: EmployersScreen())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    final dialogFinder = find.byType(Dialog);
    expect(dialogFinder, findsOneWidget);
    expect(
      find.descendant(of: dialogFinder, matching: find.text('Choose')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: dialogFinder,
        matching: find.text('Create New Venue'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: dialogFinder,
        matching: find.text('Request to Join Existing Venue'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialogFinder, matching: find.text('Help Desk')),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Choose'), findsNothing);
  });

  testWidgets('Plus opens promoter-aware dialog on promoters tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _withEmployersBloc(const MaterialApp(home: EmployersScreen())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Promoters'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    final dialogFinder = find.byType(Dialog);
    expect(dialogFinder, findsOneWidget);
    expect(
      find.descendant(
        of: dialogFinder,
        matching: find.text('Create New Promoter'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: dialogFinder,
        matching: find.text('Request to Join Existing Promoter'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: dialogFinder, matching: find.text('Help Desk')),
      findsOneWidget,
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Create New Promoter'), findsNothing);
  });

  testWidgets('Create New Venue empty-state button opens venue welcome flow', (
    WidgetTester tester,
  ) async {
    final router = _routerForEmployersTests();

    await tester.pumpWidget(
      _withEmployersBloc(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create New Venue'));
    await tester.pumpAndSettle();

    expect(find.byType(VenueWelcomeScreen), findsOneWidget);
  });

  testWidgets('Create New Venue in plus dialog opens venue welcome flow', (
    WidgetTester tester,
  ) async {
    final router = _routerForEmployersTests();

    await tester.pumpWidget(
      _withEmployersBloc(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create New Venue').last);
    await tester.pumpAndSettle();

    expect(find.byType(VenueWelcomeScreen), findsOneWidget);
  });
}
