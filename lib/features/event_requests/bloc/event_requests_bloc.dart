import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_event_requests.dart';
import 'event_requests_event.dart';
import 'event_requests_state.dart';

class EventRequestsBloc extends Bloc<EventRequestsEvent, EventRequestsState> {
  final Map<String, String> _statusOverrides = {};

  EventRequestsBloc() : super(EventRequestsInitial()) {
    on<EventRequestsLoaded>(_onLoaded);
    on<EventRequestsStatusChanged>(_onStatusChanged);
  }

  void _onLoaded(EventRequestsLoaded event, Emitter<EventRequestsState> emit) {
    emit(EventRequestsLoadSuccess(
      requests: List.of(mockEventRequests),
      statusOverrides: Map.of(_statusOverrides),
    ));
  }

  void _onStatusChanged(EventRequestsStatusChanged event, Emitter<EventRequestsState> emit) {
    _statusOverrides[event.requestId] = event.newStatus;
    if (state is EventRequestsLoadSuccess) {
      final s = state as EventRequestsLoadSuccess;
      emit(EventRequestsLoadSuccess(
        requests: s.requests,
        statusOverrides: Map.of(_statusOverrides),
      ));
    }
  }

  String getStatus(MockEventRequest r) => _statusOverrides[r.id] ?? r.status;
}
