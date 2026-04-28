import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/my_account/bloc/settings_bloc.dart';
import 'package:focus_social_club/features/my_account/bloc/settings_event.dart';
import 'package:focus_social_club/features/my_account/bloc/settings_state.dart';

void main() {
  test('SettingsBloc starts with notification toggles enabled', () {
    final bloc = SettingsBloc();

    expect(bloc.state.smsMessagesEnabled, isTrue);
    expect(bloc.state.inAppNotificationsEnabled, isTrue);
    expect(bloc.state.status, SettingsStatus.idle);

    bloc.dispose();
  });

  test('SettingsBloc updates SMS toggle state', () async {
    final bloc = SettingsBloc();

    bloc.add(const SmsMessagesToggled(false));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.smsMessagesEnabled, isFalse);

    bloc.dispose();
  });

  test('SettingsBloc updates in-app toggle state', () async {
    final bloc = SettingsBloc();

    bloc.add(const InAppNotificationsToggled(false));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.inAppNotificationsEnabled, isFalse);

    bloc.dispose();
  });

  test('SettingsBloc logout event sets logoutSuccess', () async {
    final bloc = SettingsBloc();

    bloc.add(const SettingsLogoutPressed());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, SettingsStatus.logoutSuccess);

    bloc.dispose();
  });

  test('SettingsBloc delete event sets deleteSuccess', () async {
    final bloc = SettingsBloc();

    bloc.add(const DeleteAccountPressed());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.status, SettingsStatus.deleteSuccess);

    bloc.dispose();
  });
}
