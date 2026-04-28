import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/my_account/bloc/my_account_bloc.dart';
import 'package:focus_social_club/features/my_account/bloc/my_account_event.dart';
import 'package:focus_social_club/features/my_account/bloc/my_account_state.dart';

void main() {
  test('MyAccountBloc starts in idle state', () {
    final bloc = MyAccountBloc();

    expect(bloc.state.status, MyAccountStatus.idle);

    bloc.dispose();
  });

  test('Save changes emits save success', () async {
    final bloc = MyAccountBloc();

    bloc.add(const SaveChangesPressed());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, MyAccountStatus.saveSuccess);

    bloc.dispose();
  });

  test('Logout emits logout success', () async {
    final bloc = MyAccountBloc();

    bloc.add(const LogoutPressed());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, MyAccountStatus.logoutSuccess);

    bloc.dispose();
  });

  test('ClearAccountStatus returns to idle', () async {
    final bloc = MyAccountBloc();

    bloc.add(const SaveChangesPressed());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.status, MyAccountStatus.saveSuccess);

    bloc.add(const ClearAccountStatus());
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.status, MyAccountStatus.idle);

    bloc.dispose();
  });
}
