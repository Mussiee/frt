import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/employers/bloc/employers_bloc.dart';
import 'package:focus_social_club/features/employers/screens/employers_screen.dart';
import 'package:focus_social_club/features/my_account/bloc/my_account_bloc.dart';
import 'package:focus_social_club/features/my_account/bloc/settings_bloc.dart';
import 'package:focus_social_club/features/my_account/screens/my_account_screen.dart';
import 'package:focus_social_club/features/my_account/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

Widget _withBlocs(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<EmployersBloc>(create: (_) => EmployersBloc()),
      BlocProvider<MyAccountBloc>(create: (_) => MyAccountBloc()),
      BlocProvider<SettingsBloc>(create: (_) => SettingsBloc()),
    ],
    child: child,
  );
}

GoRouter _routerForSettingsTests({required String initialLocation}) {
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
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => const Scaffold(body: Text('Intro Route')),
      ),
    ],
  );
}

void main() {
  testWidgets('Settings icon opens settings screen', (
    WidgetTester tester,
  ) async {
    final router = _routerForSettingsTests(initialLocation: '/my-account');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
  });

  testWidgets('Delete account shows warning dialog and cancel closes it', (
    WidgetTester tester,
  ) async {
    final router = _routerForSettingsTests(initialLocation: '/settings');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();

    expect(find.text('Warning'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Warning'), findsNothing);
  });

  testWidgets('Delete account shows red snackbar and goes to intro', (
    WidgetTester tester,
  ) async {
    final router = _routerForSettingsTests(initialLocation: '/settings');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Account Deleted'), findsOneWidget);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, Colors.red);

    await tester.pump(const Duration(milliseconds: 4000));
    await tester.pumpAndSettle();

    expect(find.text('Intro Route'), findsOneWidget);
  });

  testWidgets('Log out from settings goes to intro', (
    WidgetTester tester,
  ) async {
    final router = _routerForSettingsTests(initialLocation: '/settings');

    await tester.pumpWidget(
      _withBlocs(MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    expect(find.text('Intro Route'), findsOneWidget);
  });
}
