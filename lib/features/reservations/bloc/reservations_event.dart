import 'package:equatable/equatable.dart';

abstract class ReservationsEvent extends Equatable {
  const ReservationsEvent();
  @override
  List<Object?> get props => [];
}

class ReservationsLoaded extends ReservationsEvent {}

class ReservationsFilterChanged extends ReservationsEvent {
  final String filter;
  const ReservationsFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class ReservationsSearchChanged extends ReservationsEvent {
  final String query;
  const ReservationsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class ReservationsPageChanged extends ReservationsEvent {
  final int page;
  const ReservationsPageChanged(this.page);
  @override
  List<Object?> get props => [page];
}

class ReservationStatusUpdated extends ReservationsEvent {
  final String reservationId;
  final String newStatus;
  const ReservationStatusUpdated(this.reservationId, this.newStatus);
  @override
  List<Object?> get props => [reservationId, newStatus];
}
