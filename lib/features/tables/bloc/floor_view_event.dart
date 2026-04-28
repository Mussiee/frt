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
