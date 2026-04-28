import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../mock_session.dart';

class RoleState extends Equatable {
  final UserRole role;

  const RoleState({this.role = UserRole.owner});

  String get roleLabel {
    switch (role) {
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
    switch (role) {
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

  @override
  List<Object> get props => [role];
}

class RoleCubit extends Cubit<RoleState> {
  RoleCubit() : super(const RoleState());

  void setRole(UserRole role) => emit(RoleState(role: role));
}
