import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/auth/bloc/auth_state.dart';
import 'package:focus_social_club/features/auth/data/repositories/auth_repository.dart';
import 'package:focus_social_club/features/auth/presentation/screens/splash_screen.dart';
import 'package:focus_social_club/utils/theme/app_theme.dart';

Widget _themed(Widget child) => MaterialApp(theme: AppTheme.dark, home: child);

void main() {
  // ── AuthRepository ─────────────────────────────────────────────────────────
  group('AuthRepository', () {
    test('instantiates without error', () {
      expect(AuthRepository(), isNotNull);
    });
  });

  // ── State classes (pure Dart — no Firebase SDK needed) ─────────────────────
  group('AuthState', () {
    test('OtpVerified holds phone and idToken', () {
      const state = OtpVerified(phone: '+1555000000', idToken: 'tok-abc');
      expect(state.phone, '+1555000000');
      expect(state.idToken, 'tok-abc');
      expect(state.props, ['+1555000000', 'tok-abc']);
    });

    test('OtpSent holds phone and optional devCode', () {
      const a = OtpSent(phone: '+1555000000');
      expect(a.phone, '+1555000000');
      expect(a.devCode, isNull);

      const b = OtpSent(phone: '+1555000000', devCode: '123123');
      expect(b.devCode, '123123');
    });

    test('AuthError holds message', () {
      const state = AuthError(message: 'Network error');
      expect(state.message, 'Network error');
    });

    test('AuthInitial == AuthInitial', () {
      expect(const AuthInitial(), equals(const AuthInitial()));
    });

    test('AuthLoading == AuthLoading', () {
      expect(const AuthLoading(), equals(const AuthLoading()));
    });
  });

  // ── Widget smoke tests (no Firebase required) ──────────────────────────────
  group('SplashScreen', () {
    testWidgets('shows FOCUS, EXCLUSIVE ACCESS, and CONTINUE', (tester) async {
      await tester.pumpWidget(_themed(const SplashScreen()));
      await tester.pumpAndSettle();
      expect(find.text('FOCUS'), findsOneWidget);
      expect(find.text('EXCLUSIVE ACCESS'), findsOneWidget);
      expect(find.text('CONTINUE'), findsOneWidget);
    });
  });

  // Note: PhoneEntryScreen and OtpVerifyScreen tests require
  // Firebase.initializeApp() — run them as integration tests with
  // flutter test integration_test/ instead.
}
