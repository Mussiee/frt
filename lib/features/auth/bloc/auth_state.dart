import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Firebase OTP has been sent; verificationId is stored in BLoC.
class OtpSent extends AuthState {
  final String phone;
  /// Shown in dev/testing mode when BYPASS is active (devCode from backend).
  final String? devCode;
  const OtpSent({required this.phone, this.devCode});
  @override
  List<Object?> get props => [phone, devCode];
}

/// OTP verified by Firebase. idToken can be used for backend API calls.
class OtpVerified extends AuthState {
  final String phone;
  final String idToken; // Firebase ID token — use as Bearer for backend
  const OtpVerified({required this.phone, required this.idToken});
  @override
  List<Object?> get props => [phone, idToken];
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}
