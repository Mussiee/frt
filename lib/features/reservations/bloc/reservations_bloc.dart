import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_reservations.dart';
import 'reservations_event.dart';
import 'reservations_state.dart';

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  static const int _pageSize = 10;
  List<MockReservation> _all = [];
  final Map<String, String> _statusOverrides = {};

  ReservationsBloc() : super(ReservationsInitial()) {
    on<ReservationsLoaded>(_onLoaded);
    on<ReservationsFilterChanged>(_onFilterChanged);
    on<ReservationsSearchChanged>(_onSearchChanged);
    on<ReservationsPageChanged>(_onPageChanged);
    on<ReservationStatusUpdated>(_onStatusUpdated);
  }

  void _onLoaded(ReservationsLoaded event, Emitter<ReservationsState> emit) {
    _all = List.of(mockReservations);
    emit(_buildSuccess(filter: 'ALL', search: '', page: 1));
  }

  void _onFilterChanged(ReservationsFilterChanged event, Emitter<ReservationsState> emit) {
    if (state is ReservationsLoadSuccess) {
      final s = state as ReservationsLoadSuccess;
      emit(_buildSuccess(filter: event.filter, search: s.search, page: 1));
    }
  }

  void _onSearchChanged(ReservationsSearchChanged event, Emitter<ReservationsState> emit) {
    if (state is ReservationsLoadSuccess) {
      final s = state as ReservationsLoadSuccess;
      emit(_buildSuccess(filter: s.filter, search: event.query, page: 1));
    }
  }

  void _onPageChanged(ReservationsPageChanged event, Emitter<ReservationsState> emit) {
    if (state is ReservationsLoadSuccess) {
      final s = state as ReservationsLoadSuccess;
      emit(_buildSuccess(filter: s.filter, search: s.search, page: event.page));
    }
  }

  void _onStatusUpdated(ReservationStatusUpdated event, Emitter<ReservationsState> emit) {
    _statusOverrides[event.reservationId] = event.newStatus;
    if (state is ReservationsLoadSuccess) {
      final s = state as ReservationsLoadSuccess;
      emit(_buildSuccess(filter: s.filter, search: s.search, page: s.page));
    }
  }

  String getStatus(MockReservation r) => _statusOverrides[r.id] ?? r.status;

  ReservationsLoadSuccess _buildSuccess({required String filter, required String search, required int page}) {
    var list = _all.toList();
    if (filter != 'ALL') {
      final key = filter.toLowerCase().replaceAll(' ', '_');
      list = list.where((r) => getStatus(r) == key).toList();
    }
    if (search.isNotEmpty) {
      list = list.where((r) => r.customerName.toLowerCase().contains(search.toLowerCase())).toList();
    }
    final totalPages = (list.length / _pageSize).ceil().clamp(1, 99);
    return ReservationsLoadSuccess(
      reservations: _all,
      filtered: list,
      filter: filter,
      search: search,
      page: page,
      totalPages: totalPages,
    );
  }
}
