import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// User tapped Continue on PhoneEntryScreen.
class PhoneSubmitted extends AuthEvent {
  final String phone; // E.164 format
  const PhoneSubmitted({required this.phone});
  @override
  List<Object?> get props => [phone];
}

/// Firebase called back with a verificationId (Android silent/native).
/// Treated the same as the web flow completing — we wait for OTP entry.
class FirebaseCodeSent extends AuthEvent {
  final String verificationId;
  const FirebaseCodeSent({required this.verificationId});
  @override
  List<Object?> get props => [verificationId];
}

/// User submitted the 6-digit OTP code.
class OtpSubmitted extends AuthEvent {
  final String code;
  const OtpSubmitted({required this.code});
  @override
  List<Object?> get props => [code];
}

/// User requested a fresh OTP.
class ResendOtpRequested extends AuthEvent {
  const ResendOtpRequested();
}
