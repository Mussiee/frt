import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/venue_registration/bloc/venue_registration_bloc.dart';
import 'package:focus_social_club/features/venue_registration/screens/venue_registration_screen.dart';
import 'package:focus_social_club/features/venue_welcome/screens/venue_welcome_screen.dart';
import 'package:go_router/go_router.dart';

Widget _withVenueRegistrationBloc(Widget child) {
  return BlocProvider<VenueRegistrationBloc>(
    create: (_) => VenueRegistrationBloc(),
    child: child,
  );
}

void main() {
  testWidgets('Venue welcome renders first slide and register button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VenueWelcomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Feature highlight'), findsOneWidget);
    expect(find.text('WORK SMARTER. SCALE FASTER.'), findsOneWidget);
    expect(find.text('Register Venue'), findsOneWidget);
  });

  testWidgets('Venue welcome supports swipe to next slide', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VenueWelcomeScreen()));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('MANAGE TABLES WITH PRECISION'), findsOneWidget);
  });

  testWidgets('Venue welcome includes eleventh register slide', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: VenueWelcomeScreen()));
    await tester.pumpAndSettle();

    for (int i = 0; i < 10; i++) {
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
    }

    expect(find.text('WELCOME TO MY VENUE'), findsOneWidget);
    expect(find.text('REGISTER TODAY'), findsOneWidget);
    expect(find.text('& Much More'), findsOneWidget);
  });

  testWidgets('Close button pops back to previous screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/venue-welcome',
        routes: {
          '/': (_) => const Scaffold(body: Text('Create Venue Screen')),
          '/venue-welcome': (_) => const VenueWelcomeScreen(),
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('Create Venue Screen'), findsOneWidget);
  });

  testWidgets('Register Venue navigates to registration flow', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/venue-welcome',
      routes: [
        GoRoute(
          path: '/venue-welcome',
          builder: (context, state) => const VenueWelcomeScreen(),
        ),
        GoRoute(
          path: '/venue-registration',
          builder: (context, state) => const VenueRegistrationScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      _withVenueRegistrationBloc(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Register Venue'));
    await tester.pumpAndSettle();

    expect(find.byType(VenueRegistrationScreen), findsOneWidget);
  });
}
