import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/table_circle.dart';
import '../data/mock_tables.dart';
import 'floor_view_event.dart';
import 'floor_view_state.dart';

class FloorViewBloc extends Bloc<FloorViewEvent, FloorViewState> {
  List<MockTable> _tables = [];

  FloorViewBloc() : super(FloorViewInitial()) {
    on<FloorViewLoaded>(_onLoaded);
    on<FloorViewZoneChanged>(_onZoneChanged);
    on<FloorViewTableSelected>(_onTableSelected);
    on<FloorViewTableStatusChanged>(_onStatusChanged);
    on<FloorViewModeChanged>(_onModeChanged);
    on<FloorViewEventSelected>(_onEventSelected);
    on<FloorViewTableCustomerAssigned>(_onCustomerAssigned);
    on<FloorViewTableServerAssigned>(_onServerAssigned);
    on<FloorViewTableMarkedNoShow>(_onMarkedNoShow);
  }

  void _onLoaded(FloorViewLoaded event, Emitter<FloorViewState> emit) {
    _tables = List.of(mockTables);
    emit(FloorViewLoadSuccess(
      tables: _tables,
      currentZone: zones.first,
      zoneNames: zones,
      availableEvents: mockEvents,
    ));
  }

  void _onZoneChanged(FloorViewZoneChanged event, Emitter<FloorViewState> emit) {
    if (state is FloorViewLoadSuccess) {
      final s = state as FloorViewLoadSuccess;
      emit(FloorViewLoadSuccess(
        tables: _tables,
        currentZone: event.zone,
        selectedTableId: null,
        zoneNames: s.zoneNames,
        isEventMode: s.isEventMode,
        selectedEventId: s.selectedEventId,
        availableEvents: s.availableEvents,
      ));
    }
  }

  void _onTableSelected(FloorViewTableSelected event, Emitter<FloorViewState> emit) {
    if (state is FloorViewLoadSuccess) {
      final s = state as FloorViewLoadSuccess;
      emit(FloorViewLoadSuccess(
        tables: _tables,
        currentZone: s.currentZone,
        selectedTableId: event.tableId,
        zoneNames: s.zoneNames,
        isEventMode: s.isEventMode,
        selectedEventId: s.selectedEventId,
        availableEvents: s.availableEvents,
      ));
    }
  }

  void _onStatusChanged(FloorViewTableStatusChanged event, Emitter<FloorViewState> emit) {
    _updateTable(event.tableId, (t) => t.copyWith(status: event.newStatus));
    _emitCurrent(emit);
  }

  void _onModeChanged(FloorViewModeChanged event, Emitter<FloorViewState> emit) {
    if (state is FloorViewLoadSuccess) {
      final s = state as FloorViewLoadSuccess;
      emit(FloorViewLoadSuccess(
        tables: _tables,
        currentZone: s.currentZone,
        selectedTableId: null,
        zoneNames: s.zoneNames,
        isEventMode: event.isEventMode,
        selectedEventId: event.isEventMode ? (s.selectedEventId ?? mockEvents.first.id) : null,
        availableEvents: s.availableEvents,
      ));
    }
  }

  void _onEventSelected(FloorViewEventSelected event, Emitter<FloorViewState> emit) {
    if (state is FloorViewLoadSuccess) {
      final s = state as FloorViewLoadSuccess;
      emit(FloorViewLoadSuccess(
        tables: _tables,
        currentZone: s.currentZone,
        selectedTableId: null,
        zoneNames: s.zoneNames,
        isEventMode: true,
        selectedEventId: event.eventId,
        availableEvents: s.availableEvents,
      ));
    }
  }

  void _onCustomerAssigned(FloorViewTableCustomerAssigned event, Emitter<FloorViewState> emit) {
    _updateTable(event.tableId, (t) => t.copyWith(
      status: TableStatus.reserved,
      customerName: event.customerName,
      customerPhone: event.customerPhone,
      guestCount: event.guestCount,
    ));
    _emitCurrent(emit);
  }

  void _onServerAssigned(FloorViewTableServerAssigned event, Emitter<FloorViewState> emit) {
    _updateTable(event.tableId, (t) => t.copyWith(serverName: event.serverName));
    _emitCurrent(emit);
  }

  void _onMarkedNoShow(FloorViewTableMarkedNoShow event, Emitter<FloorViewState> emit) {
    _updateTable(event.tableId, (t) => t.copyWith(
      status: TableStatus.free,
      customerName: null,
      customerPhone: null,
      guestCount: null,
      serverName: null,
      totalSpend: null,
      sessionDuration: null,
    ));
    _emitCurrent(emit);
  }

  void _updateTable(String tableId, MockTable Function(MockTable) updater) {
    final idx = _tables.indexWhere((t) => t.id == tableId);
    if (idx != -1) {
      _tables[idx] = updater(_tables[idx]);
    }
  }

  void _emitCurrent(Emitter<FloorViewState> emit) {
    if (state is FloorViewLoadSuccess) {
      final s = state as FloorViewLoadSuccess;
      emit(FloorViewLoadSuccess(
        tables: _tables,
        currentZone: s.currentZone,
        selectedTableId: s.selectedTableId,
        zoneNames: s.zoneNames,
        isEventMode: s.isEventMode,
        selectedEventId: s.selectedEventId,
        availableEvents: s.availableEvents,
      ));
    }
  }
}
