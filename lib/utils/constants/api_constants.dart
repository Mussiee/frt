// Single source of truth for all backend API endpoints.
//
// Running on a real Android device?
//   Replace 'localhost' with your machine's LAN IP, e.g. '192.168.1.42:3000'
//   OR pass --dart-define=API_BASE_URL=http://192.168.1.42:3000
//
// Android Emulator:  10.0.2.2:3000
// iOS Simulator:     localhost:3000  (127.0.0.1 works too)
// Real device:       <LAN-IP>:3000
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  // ── Auth / Phone ──────────────────────────────────────────────────────────
  static const String sendOtp = '$baseUrl/api/v2/reservations/phone/send-otp';
  static const String verifyOtp = '$baseUrl/api/v2/reservations/phone/verify-otp';
}
