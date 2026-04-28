import 'package:equatable/equatable.dart';
import '../data/mock_reservations.dart';

abstract class ReservationsState extends Equatable {
  const ReservationsState();
  @override
  List<Object?> get props => [];
}

class ReservationsInitial extends ReservationsState {}

class ReservationsLoading extends ReservationsState {}

class ReservationsLoadSuccess extends ReservationsState {
  final List<MockReservation> reservations;
  final List<MockReservation> filtered;
  final String filter;
  final String search;
  final int page;
  final int totalPages;

  const ReservationsLoadSuccess({
    required this.reservations,
    required this.filtered,
    this.filter = 'ALL',
    this.search = '',
    this.page = 1,
    this.totalPages = 1,
  });

  @override
  List<Object?> get props => [reservations, filtered, filter, search, page];
}

class ReservationsLoadFailure extends ReservationsState {
  final String message;
  const ReservationsLoadFailure(this.message);
  @override
  List<Object?> get props => [message];
}
