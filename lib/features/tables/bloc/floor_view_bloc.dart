import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_tables.dart';
import 'floor_view_event.dart';
import 'floor_view_state.dart';

class FloorViewBloc extends Bloc<FloorViewEvent, FloorViewState> {
  List<MockTable> _all = [];

  FloorViewBloc() : super(FloorViewInitial()) {
    on<FloorViewLoaded>(_onLoaded);
    on<FloorViewZoneChanged>(_onZoneChanged);
    on<FloorViewTableSelected>(_onTableSelected);
    on<FloorViewTableStatusChanged>(_onTableStatusChanged);
  }

  void _onLoaded(FloorViewLoaded event, Emitter<FloorViewState> emit) {
    _all = List.of(mockTables);
    emit(_buildSuccess(zone: 'ROOFTOP', selectedTableId: null));
  }

  void _onZoneChanged(FloorViewZoneChanged event, Emitter<FloorViewState> emit) {
    emit(_buildSuccess(zone: event.zone, selectedTableId: null));
  }

  void _onTableSelected(FloorViewTableSelected event, Emitter<FloorViewState> emit) {
    if (state is FloorViewLoadSuccess) {
      final s = state as FloorViewLoadSuccess;
      emit(_buildSuccess(zone: s.currentZone, selectedTableId: event.tableId));
    }
  }

  void _onTableStatusChanged(FloorViewTableStatusChanged event, Emitter<FloorViewState> emit) {
    _all = _all.map((t) {
      if (t.id == event.tableId) {
        return MockTable(
          id: t.id,
          label: t.label,
          zone: t.zone,
          status: event.newStatus,
          capacity: t.capacity,
          tableType: t.tableType,
          sizeMultiplier: t.sizeMultiplier,
          customerName: t.customerName,
          customerPhone: t.customerPhone,
          serverName: t.serverName,
          serverRole: t.serverRole,
          reservationDate: t.reservationDate,
          guestCount: t.guestCount,
          totalSpend: t.totalSpend,
          sessionDuration: t.sessionDuration,
          notes: t.notes,
          area: t.area,
          x: t.x,
          y: t.y,
        );
      }
      return t;
    }).toList();
    if (state is FloorViewLoadSuccess) {
      final s = state as FloorViewLoadSuccess;
      emit(_buildSuccess(zone: s.currentZone, selectedTableId: s.selectedTableId));
    }
  }

  FloorViewLoadSuccess _buildSuccess({required String zone, required String? selectedTableId}) {
    final filtered = _all.where((t) => t.zone == zone).toList();
    return FloorViewLoadSuccess(
      tables: filtered,
      currentZone: zone,
      selectedTableId: selectedTableId,
      zoneNames: zones,
    );
  }
}
