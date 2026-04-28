import 'package:equatable/equatable.dart';

abstract class EventRequestsEvent extends Equatable {
  const EventRequestsEvent();
  @override
  List<Object?> get props => [];
}

class EventRequestsLoaded extends EventRequestsEvent {}

class EventRequestsStatusChanged extends EventRequestsEvent {
  final String requestId;
  final String newStatus;
  const EventRequestsStatusChanged(this.requestId, this.newStatus);
  @override
  List<Object?> get props => [requestId, newStatus];
}
