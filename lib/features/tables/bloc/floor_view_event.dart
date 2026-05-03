import 'package:equatable/equatable.dart';
import '../../../shared/widgets/table_circle.dart';

abstract class FloorViewEvent extends Equatable {
  const FloorViewEvent();
  @override
  List<Object?> get props => [];
}

class FloorViewLoaded extends FloorViewEvent {}

class FloorViewZoneChanged extends FloorViewEvent {
  final String zone;
  const FloorViewZoneChanged(this.zone);
  @override
  List<Object?> get props => [zone];
}

class FloorViewTableSelected extends FloorViewEvent {
  final String? tableId;
  const FloorViewTableSelected(this.tableId);
  @override
  List<Object?> get props => [tableId];
}

class FloorViewTableStatusChanged extends FloorViewEvent {
  final String tableId;
  final TableStatus newStatus;
  const FloorViewTableStatusChanged(this.tableId, this.newStatus);
  @override
  List<Object?> get props => [tableId, newStatus];
}

class FloorViewModeChanged extends FloorViewEvent {
  final bool isEventMode;
  const FloorViewModeChanged(this.isEventMode);
  @override
  List<Object?> get props => [isEventMode];
}

class FloorViewEventSelected extends FloorViewEvent {
  final String eventId;
  const FloorViewEventSelected(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class FloorViewTableCustomerAssigned extends FloorViewEvent {
  final String tableId;
  final String customerName;
  final String? customerPhone;
  final int guestCount;
  const FloorViewTableCustomerAssigned({
    required this.tableId,
    required this.customerName,
    this.customerPhone,
    required this.guestCount,
  });
  @override
  List<Object?> get props => [tableId, customerName, customerPhone, guestCount];
}

class FloorViewTableServerAssigned extends FloorViewEvent {
  final String tableId;
  final String serverName;
  const FloorViewTableServerAssigned({
    required this.tableId,
    required this.serverName,
  });
  @override
  List<Object?> get props => [tableId, serverName];
}

class FloorViewTableMarkedNoShow extends FloorViewEvent {
  final String tableId;
  const FloorViewTableMarkedNoShow(this.tableId);
  @override
  List<Object?> get props => [tableId];
}
