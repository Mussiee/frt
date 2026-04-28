import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/venue_registration/bloc/venue_registration_bloc.dart';
import 'package:focus_social_club/features/venue_registration/bloc/venue_registration_event.dart';
import 'package:focus_social_club/features/venue_registration/bloc/venue_registration_state.dart';

void main() {
  Future<void> flushBlocQueue() async {
    await Future<void>.delayed(Duration.zero);
  }

  test(
    'step one stays invalid with bad email and becomes valid with proper email',
    () async {
      final bloc = VenueRegistrationBloc();

      bloc.add(
        const VenueRegistrationFieldChanged(
          field: VenueRegistrationField.name,
          value: 'Jane Doe',
        ),
      );
      bloc.add(
        const VenueRegistrationFieldChanged(
          field: VenueRegistrationField.email,
          value: 'invalid-email',
        ),
      );
      await flushBlocQueue();

      expect(bloc.state.isCurrentStepValid, isFalse);
      expect(bloc.state.emailError, 'Enter a valid email');

      bloc.add(
        const VenueRegistrationFieldChanged(
          field: VenueRegistrationField.email,
          value: 'jane@example.com',
        ),
      );
      await flushBlocQueue();

      expect(bloc.state.isCurrentStepValid, isTrue);
      expect(bloc.state.emailError, isNull);

      bloc.dispose();
    },
  );

  test('next only advances when current step is valid', () async {
    final bloc = VenueRegistrationBloc();

    bloc.add(const VenueRegistrationNextPressed());
    await flushBlocQueue();
    expect(bloc.state.currentStep, 0);

    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.name,
        value: 'Jane Doe',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.email,
        value: 'jane@example.com',
      ),
    );
    await flushBlocQueue();

    bloc.add(const VenueRegistrationNextPressed());
    await flushBlocQueue();
    expect(bloc.state.currentStep, 1);

    bloc.dispose();
  });

  test('final valid step sets completed status', () async {
    final bloc = VenueRegistrationBloc();

    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.name,
        value: 'Jane Doe',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.email,
        value: 'jane@example.com',
      ),
    );
    await flushBlocQueue();
    bloc.add(const VenueRegistrationNextPressed());
    await flushBlocQueue();

    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.venueName,
        value: 'Focus Downtown',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.capacity,
        value: '400',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.currency,
        value: 'USD',
      ),
    );
    await flushBlocQueue();
    bloc.add(const VenueRegistrationNextPressed());
    await flushBlocQueue();

    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.address,
        value: '12 Main Street',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.city,
        value: 'New York',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.stateProvince,
        value: 'NY',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.country,
        value: 'USA',
      ),
    );
    bloc.add(
      const VenueRegistrationFieldChanged(
        field: VenueRegistrationField.zipCode,
        value: '10001',
      ),
    );
    await flushBlocQueue();

    bloc.add(const VenueRegistrationNextPressed());
    await flushBlocQueue();

    expect(bloc.state.status, VenueRegistrationStatus.completed);

    bloc.dispose();
  });
}
