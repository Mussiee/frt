import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../utils/constants/api_constants.dart';

// AuthRepository is now only needed for creating reservations and
// other backend API calls that require the Firebase idToken.
// Phone OTP is handled entirely by firebase_auth in AuthBloc.
class AuthRepository {
  final http.Client _client;

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  // ── Protected API helper ───────────────────────────────────────────────────

  /// GET any protected endpoint using the Firebase Bearer token.
  Future<Map<String, dynamic>> authenticatedGet({
    required String endpoint,
    required String idToken,
  }) async {
    final res = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400) {
      throw Exception(body['error'] ?? 'Request failed (${res.statusCode})');
    }
    return body;
  }

  /// POST to a protected endpoint using the Firebase Bearer token.
  Future<Map<String, dynamic>> authenticatedPost({
    required String endpoint,
    required String idToken,
    required Map<String, dynamic> payload,
  }) async {
    final res = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode(payload),
    );
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400) {
      throw Exception(body['error'] ?? 'Request failed (${res.statusCode})');
    }
    return body;
  }
}
