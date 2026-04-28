import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final FirebaseAuth _firebaseAuth;

  String _currentPhone = '';
  // Web flow: confirmation result from signInWithPhoneNumber.
  ConfirmationResult? _webConfirmation;
  // Native flow: verificationId from verifyPhoneNumber callback.
  String? _nativeVerificationId;

  AuthBloc({
    required this.repository,
    FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(const AuthInitial()) {
    on<PhoneSubmitted>(_onPhoneSubmitted);
    on<FirebaseCodeSent>(_onFirebaseCodeSent);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<ResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onPhoneSubmitted(
    PhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    _currentPhone = event.phone;
    try {
      if (kIsWeb) {
        await _sendOtpWeb(event.phone, emit);
      } else {
        await _sendOtpNative(event.phone, emit);
      }
    } catch (e) {
      emit(AuthError(message: _friendlyError(e)));
    }
  }

  // ── Web (Chrome) ───────────────────────────────────────────────────────────
  // Uses signInWithPhoneNumber with an invisible RecaptchaVerifier.

  Future<void> _sendOtpWeb(String phone, Emitter<AuthState> emit) async {
    // FirebaseAuth.signInWithPhoneNumber automatically creates a default invisible
    // RecaptchaVerifier (using its internal delegate) if the parameter is omitted.
    _webConfirmation = await _firebaseAuth.signInWithPhoneNumber(phone);
    emit(OtpSent(phone: phone));
  }

  // ── Native (Android / iOS) ─────────────────────────────────────────────────
  // Uses verifyPhoneNumber — no reCAPTCHA widget needed.

  Future<void> _sendOtpNative(String phone, Emitter<AuthState> emit) async {
    // Use a completer pattern so we can emit from inside the callbacks.
    final completer = _OtpCompleter();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieved (Android SMS picker) — sign in immediately.
        try {
          final result = await _firebaseAuth.signInWithCredential(credential);
          final token = await result.user?.getIdToken() ?? '';
          completer.complete(_NativeResult.autoVerified(token));
        } catch (e) {
          completer.complete(_NativeResult.error(_friendlyError(e)));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        completer.complete(_NativeResult.error(_friendlyError(e)));
      },
      codeSent: (String verificationId, int? resendToken) {
        _nativeVerificationId = verificationId;
        completer.complete(_NativeResult.codeSent());
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    final result = await completer.future;
    if (result.isError) {
      emit(AuthError(message: result.error!));
    } else if (result.isAutoVerified) {
      emit(OtpVerified(phone: phone, idToken: result.idToken!));
    } else {
      emit(OtpSent(phone: phone));
    }
  }

  void _onFirebaseCodeSent(FirebaseCodeSent event, Emitter<AuthState> emit) {
    _nativeVerificationId = event.verificationId;
    emit(OtpSent(phone: _currentPhone));
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      UserCredential result;
      if (kIsWeb) {
        // Web: use the stored ConfirmationResult.
        if (_webConfirmation == null) {
          emit(const AuthError(message: 'Session expired. Please try again.'));
          return;
        }
        result = await _webConfirmation!.confirm(event.code);
      } else {
        // Native: use verificationId + user-entered code.
        final cred = PhoneAuthProvider.credential(
          verificationId: _nativeVerificationId ?? '',
          smsCode: event.code,
        );
        result = await _firebaseAuth.signInWithCredential(cred);
      }
      final idToken = await result.user?.getIdToken() ?? '';
      if (idToken.isEmpty) {
        emit(const AuthError(message: 'Failed to get auth token.'));
        return;
      }
      emit(OtpVerified(phone: _currentPhone, idToken: idToken));
    } on FirebaseAuthException catch (e) {
      // Re-emit OtpSent so the user can retry without going back.
      emit(OtpSent(phone: _currentPhone));
      emit(AuthError(message: _friendlyError(e)));
    } catch (e) {
      emit(OtpSent(phone: _currentPhone));
      emit(AuthError(message: _friendlyError(e)));
    }
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_currentPhone.isEmpty) return;
    add(PhoneSubmitted(phone: _currentPhone));
  }

  String _friendlyError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-phone-number':
          return 'Invalid phone number format.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment.';
        case 'invalid-verification-code':
          return 'Incorrect code. Please try again.';
        case 'session-expired':
          return 'Code expired. Please request a new one.';
        case 'network-request-failed':
          return 'No internet connection.';
        default:
          return e.message ?? 'Authentication failed.';
      }
    }
    final msg = e.toString().replaceFirst('Exception: ', '');
    return msg.length > 120 ? '${msg.substring(0, 120)}…' : msg;
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _NativeResult {
  final bool isError;
  final bool isAutoVerified;
  final String? error;
  final String? idToken;

  _NativeResult._({
    required this.isError,
    required this.isAutoVerified,
    this.error,
    this.idToken,
  });

  factory _NativeResult.codeSent() =>
      _NativeResult._(isError: false, isAutoVerified: false);

  factory _NativeResult.autoVerified(String token) =>
      _NativeResult._(isError: false, isAutoVerified: true, idToken: token);

  factory _NativeResult.error(String msg) =>
      _NativeResult._(isError: true, isAutoVerified: false, error: msg);
}

class _OtpCompleter {
  _NativeResult? _result;
  final List<void Function(_NativeResult)> _listeners = [];

  void complete(_NativeResult r) {
    _result = r;
    for (final l in _listeners) {
      l(r);
    }
    _listeners.clear();
  }

  Future<_NativeResult> get future async {
    if (_result != null) return _result!;
    return Future(() async {
      while (_result == null) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return _result!;
    });
  }
}
