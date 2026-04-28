import 'package:flutter_test/flutter_test.dart';
import 'package:focus_social_club/features/employers/bloc/employers_bloc.dart';
import 'package:focus_social_club/features/employers/bloc/employers_event.dart';
import 'package:focus_social_club/features/employers/bloc/employers_state.dart';

void main() {
  test('EmployersBloc starts with initial state', () {
    final bloc = EmployersBloc();

    expect(bloc.state.selectedTab, EmployersTab.venues);
    expect(bloc.state.venuesStatus, EmployersLoadStatus.initial);
    expect(bloc.state.promotersStatus, EmployersLoadStatus.initial);
    expect(bloc.state.venues, isEmpty);
    expect(bloc.state.promoters, isEmpty);

    bloc.dispose();
  });

  test('LoadEmployersData loads both venues and promoters', () async {
    final bloc = EmployersBloc(
      initialVenues: const ['Focus Soho'],
      initialPromoters: const ['Promo One'],
    );

    bloc.add(const LoadEmployersData());
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.venuesStatus, EmployersLoadStatus.loaded);
    expect(bloc.state.promotersStatus, EmployersLoadStatus.loaded);
    expect(bloc.state.venues, ['Focus Soho']);
    expect(bloc.state.promoters, ['Promo One']);

    bloc.dispose();
  });

  test('EmployersTabChanged updates selected tab', () async {
    final bloc = EmployersBloc();

    bloc.add(const EmployersTabChanged(EmployersTab.promoters));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.selectedTab, EmployersTab.promoters);

    bloc.dispose();
  });
}
