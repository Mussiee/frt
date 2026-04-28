import 'package:flutter/foundation.dart';

enum UserRole { owner, host, staff, security, promoter }

class MockSession extends ChangeNotifier {
  static final MockSession instance = MockSession._();
  MockSession._();

  UserRole _role = UserRole.owner;
  UserRole get role => _role;

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  String get userName => 'Julian Thorne';
  String get userPhone => '+1 (555) 123-4567';
  String get userInitials => 'JT';

  String get roleLabel {
    switch (_role) {
      case UserRole.owner:
        return 'OWNER';
      case UserRole.host:
        return 'HOST';
      case UserRole.staff:
        return 'STAFF';
      case UserRole.security:
        return 'SECURITY';
      case UserRole.promoter:
        return 'PROMOTER';
    }
  }

  String get defaultRoute {
    switch (_role) {
      case UserRole.owner:
      case UserRole.host:
        return '/dashboard';
      case UserRole.staff:
        return '/my-tables';
      case UserRole.security:
        return '/scanner';
      case UserRole.promoter:
        return '/my-stats';
    }
  }
}
