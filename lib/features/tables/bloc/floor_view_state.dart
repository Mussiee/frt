import 'package:equatable/equatable.dart';
import '../data/mock_tables.dart';

abstract class FloorViewState extends Equatable {
  const FloorViewState();
  @override
  List<Object?> get props => [];
}

class FloorViewInitial extends FloorViewState {}

class FloorViewLoadSuccess extends FloorViewState {
  final List<MockTable> tables;
  final String currentZone;
  final String? selectedTableId;
  final List<String> zoneNames;

  const FloorViewLoadSuccess({
    required this.tables,
    required this.currentZone,
    this.selectedTableId,
    required this.zoneNames,
  });

  @override
  List<Object?> get props => [tables, currentZone, selectedTableId, zoneNames];
}
