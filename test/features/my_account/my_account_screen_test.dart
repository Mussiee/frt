import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/employers/bloc/employers_bloc.dart';
import 'package:focus_social_club/features/employers/screens/employers_screen.dart';
import 'package:focus_social_club/features/my_account/bloc/my_account_bloc.dart';
import 'package:focus_social_club/features/my_account/screens/my_account_screen.dart';
import 'package:go_router/go_router.dart';

Widget _withBlocs(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<EmployersBloc>(create: (_) => EmployersBloc()),
      BlocProvider<MyAccountBloc>(create: (_) => MyAccountBloc()),
    ],
    child: child,
  );
}

GoRouter _routerForTest({required String initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/employers',
        builder: (context, state) => const EmployersScreen(),
      ),
      GoRoute(
        path: '/my-account',
        builder: (context, state) => const MyAccountScreen(),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const Scaffold(body: Text('Intro Route')),
      ),
    ],
  );
}

void main() {
  testWidgets('Person icon on venue opens My Account', (
    WidgetTester tester,
  ) async {
    final router = _routerForTest(initialLocation: '/employers');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('My Account'), findsOneWidget);
  });

  testWidgets('Back on My Account returns to venue screen', (
    WidgetTester tester,
  ) async {
    final router = _routerForTest(initialLocation: '/my-account');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(find.text('My Employers'), findsOneWidget);
  });

  testWidgets('Save Changes navigates back to venue screen', (
    WidgetTester tester,
  ) async {
    final router = _routerForTest(initialLocation: '/my-account');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('My Employers'), findsOneWidget);
  });

  testWidgets('Log me out navigates to intro route', (
    WidgetTester tester,
  ) async {
    final router = _routerForTest(initialLocation: '/my-account');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log me out'));
    await tester.pumpAndSettle();

    expect(find.text('Intro Route'), findsOneWidget);
  });
}
