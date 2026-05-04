import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/phone_entry_screen.dart';
import '../../features/auth/presentation/screens/otp_verify_screen.dart';
import '../../features/auth/presentation/screens/name_entry_screen.dart';
import '../../shared/widgets/role_shell_screen.dart';
import '../../shared/mock_session.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/reservations/presentation/screens/reservations_screen.dart';
import '../../features/reservations/presentation/screens/reservation_detail_screen.dart';
import '../../features/tables/presentation/screens/floor_view_screen.dart';
import '../../features/promoters/presentation/screens/promoters_screen.dart';
import '../../features/promoters/presentation/screens/promoter_detail_screen.dart';
import '../../features/crm/presentation/screens/crm_screen.dart';
import '../../features/crm/presentation/screens/customer_detail_screen.dart';
import '../../features/event_requests/presentation/screens/event_requests_screen.dart';
import '../../features/event_requests/presentation/screens/event_request_detail_screen.dart';
import '../../features/security/presentation/screens/qr_scanner_screen.dart';
import '../../features/security/presentation/screens/checked_in_screen.dart';
import '../../features/staff/presentation/screens/my_tables_screen.dart';
import '../../features/staff/presentation/screens/table_detail_server_screen.dart';
import '../../features/promoter_role/presentation/screens/my_stats_screen.dart';
import '../../features/promoter_role/presentation/screens/my_link_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/promoter_role/presentation/screens/promo_company_screen.dart';

// ─── DEV TOGGLE ──────────────────────────────────────────────────────────────
// Set to `true`  → skip login, jump straight to the app (uses MockSession role)
// Set to `false` → normal Firebase phone-auth flow
const bool kBypassAuth = true;
// ─────────────────────────────────────────────────────────────────────────────

class AppRouter {
  AppRouter._();

  static const Set<String> _authOnlyRoutes = {'/splash', '/phone', '/otp'};

  static const Set<String> _publicRoutes = {
    '/splash',
    '/phone',
    '/otp',
    '/name',
  };

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // DEV: bypass auth entirely — remove the flag above to re-enable
      if (kBypassAuth) {
        final path = state.uri.path;
        // Redirect splash/phone/otp straight to the app
        if (_authOnlyRoutes.contains(path) || path == '/') return '/home';
        return null;
      }

      final path = state.uri.path;
      final isAuthenticated = FirebaseAuth.instance.currentUser != null;

      if (!isAuthenticated && !_publicRoutes.contains(path)) {
        return '/splash';
      }
      if (isAuthenticated && _authOnlyRoutes.contains(path)) {
        return '/home';
      }
      return null;
    },
    routes: [
      // Auth routes (unchanged)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/phone',
        name: 'phone',
        builder: (context, state) => const PhoneEntryScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpVerifyScreen(),
      ),
      GoRoute(
        path: '/name',
        name: 'name',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return NameEntryScreen(
            idToken: extra['idToken'] as String? ?? '',
            phone: extra['phone'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        redirect: (context, state) => MockSession.instance.defaultRoute,
      ),

      // App shell with sidebar
      ShellRoute(
        builder: (context, state, child) => RoleShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/reservations',
            name: 'reservations',
            builder: (context, state) => const ReservationsScreen(),
          ),
          GoRoute(
            path: '/reservations/:id',
            name: 'reservation-detail',
            builder: (context, state) =>
                ReservationDetailScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/tables',
            name: 'tables',
            builder: (context, state) => const FloorViewScreen(),
          ),
          GoRoute(
            path: '/promoters',
            name: 'promoters',
            builder: (context, state) => const PromotersScreen(),
          ),
          GoRoute(
            path: '/promoters/:id',
            name: 'promoter-detail',
            builder: (context, state) =>
                PromoterDetailScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/crm',
            name: 'crm',
            builder: (context, state) => const CrmScreen(),
          ),
          GoRoute(
            path: '/crm/:id',
            name: 'customer-detail',
            builder: (context, state) =>
                CustomerDetailScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/event-requests',
            name: 'event-requests',
            builder: (context, state) => const EventRequestsScreen(),
          ),
          GoRoute(
            path: '/event-requests/:id',
            name: 'event-request-detail',
            builder: (context, state) =>
                EventRequestDetailScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/scanner',
            name: 'scanner',
            builder: (context, state) => const QrScannerScreen(),
          ),
          GoRoute(
            path: '/checked-in',
            name: 'checked-in',
            builder: (context, state) => const CheckedInScreen(),
          ),
          GoRoute(
            path: '/my-tables',
            name: 'my-tables',
            builder: (context, state) => const MyTablesScreen(),
          ),
          GoRoute(
            path: '/my-tables/:id',
            name: 'table-detail-server',
            builder: (context, state) =>
                TableDetailServerScreen(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/my-stats',
            name: 'my-stats',
            builder: (context, state) => const MyStatsScreen(),
          ),
          GoRoute(
            path: '/my-link',
            name: 'my-link',
            builder: (context, state) => const MyLinkScreen(),
          ),
          GoRoute(
            path: '/my-company',
            name: 'my-company',
            builder: (context, state) => const PromoCompanyScreen(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
