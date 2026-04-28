import 'package:equatable/equatable.dart';
import '../data/mock_event_requests.dart';

abstract class EventRequestsState extends Equatable {
  const EventRequestsState();
  @override
  List<Object?> get props => [];
}

class EventRequestsInitial extends EventRequestsState {}

class EventRequestsLoadSuccess extends EventRequestsState {
  final List<MockEventRequest> requests;
  final Map<String, String> statusOverrides;

  const EventRequestsLoadSuccess({
    required this.requests,
    this.statusOverrides = const {},
  });

  @override
  List<Object?> get props => [requests, statusOverrides];
}
