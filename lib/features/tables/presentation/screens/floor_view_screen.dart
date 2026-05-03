import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/table_circle.dart';
import '../../bloc/floor_view_bloc.dart';
import '../../bloc/floor_view_event.dart';
import '../../bloc/floor_view_state.dart';
import '../../data/mock_tables.dart';
import '../widgets/floor_zone_tab.dart';
import '../widgets/table_bottom_sheet.dart';
import '../widgets/table_circle_widget.dart';

class FloorViewScreen extends StatelessWidget {
  const FloorViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloorViewBloc, FloorViewState>(
      builder: (context, state) {
        if (state is! FloorViewLoadSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isEventMode) {
          return _buildEventView(context, state);
        }
        return _buildLiveView(context, state);
      },
    );
  }

  // ─── LIVE VIEW ──────────────────────────────────────────────────
  Widget _buildLiveView(BuildContext context, FloorViewLoadSuccess state) {
    final zoneTables = state.tables.where((t) => t.zone == state.currentZone).toList();
    final allTables = state.tables;
    final freeCount = allTables.where((t) => t.status == TableStatus.free).length;
    final reservedCount = allTables.where((t) => t.status == TableStatus.reserved).length;
    final occupiedCount = allTables.where((t) => t.status == TableStatus.occupied).length;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Mode toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text('TABLES', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                const Spacer(),
                _modeToggle(context, isEventMode: false),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _legendDot(FocusColors.success, 'FREE'),
                const SizedBox(width: 12),
                _legendDot(FocusColors.accent, 'RESERVED'),
                const SizedBox(width: 12),
                _legendDot(FocusColors.error, 'OCCUPIED'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Floor tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(state.zoneNames.length, (i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FloorZoneTab(
                    label: state.zoneNames[i],
                    isSelected: state.currentZone == state.zoneNames[i],
                    onTap: () => context.read<FloorViewBloc>().add(FloorViewZoneChanged(state.zoneNames[i])),
                  ),
                )),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Floor plan
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: FocusColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FocusColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cw = constraints.maxWidth;
                  final ch = constraints.maxHeight;
                  // Second floor has tables up to x=0.92 — give it extra horizontal room
                  final virtualW = state.currentZone == 'SECOND FLOOR' ? cw * 1.35 : cw;
                  return InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 3.0,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    child: SizedBox(
                      width: virtualW,
                      height: ch,
                      child: Stack(
                        children: [
                          ..._buildAreaLabels(state.currentZone, virtualW, ch),
                          ...zoneTables.map((table) {
                            final isCircle = table.tableType == TableType.barStool ||
                                table.tableType == TableType.circle ||
                                table.tableType == TableType.largeCircle;
                            final baseSize = 42.0 * table.sizeMultiplier;
                            final w = isCircle ? baseSize : baseSize * 1.35;
                            final h = isCircle ? baseSize : baseSize * 1.0;
                            final left = table.x * virtualW - w / 2;
                            final top = table.y * ch - h / 2;
                            return Positioned(
                              left: left.clamp(0, virtualW - w),
                              top: top.clamp(0, ch - h),
                              child: TableCircleWidget(
                                table: table,
                                isSelected: state.selectedTableId == table.id,
                                onTap: () => _onTableTap(context, table),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),

            ),
          ),
          // Summary bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: cardDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem('Total', '${allTables.length}', FocusColors.textPrimary),
                Container(width: 1, height: 24, color: FocusColors.border),
                _summaryItem('Available', '$freeCount', FocusColors.success),
                Container(width: 1, height: 24, color: FocusColors.border),
                _summaryItem('Reserved', '$reservedCount', FocusColors.accent),
                Container(width: 1, height: 24, color: FocusColors.border),
                _summaryItem('Occupied', '$occupiedCount', FocusColors.error),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── EVENT VIEW ─────────────────────────────────────────────────
  Widget _buildEventView(BuildContext context, FloorViewLoadSuccess state) {
    final selectedEvent = state.selectedEventId != null
        ? state.availableEvents.firstWhere((e) => e.id == state.selectedEventId, orElse: () => state.availableEvents.first)
        : state.availableEvents.first;

    final zoneTables = state.tables.where((t) => t.zone == state.currentZone).toList();
    final reservedInEvent = selectedEvent.reservedTableIds.length;
    final totalTables = state.tables.length;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Mode toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text('TABLES', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                const Spacer(),
                _modeToggle(context, isEventMode: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Event selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: FocusColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FocusColors.accent.withValues(alpha: 0.4)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedEvent.id,
                  isExpanded: true,
                  dropdownColor: FocusColors.elevated,
                  icon: const Icon(Icons.keyboard_arrow_down, color: FocusColors.accent),
                  items: state.availableEvents.map((e) => DropdownMenuItem(
                    value: e.id,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('${e.date} · ${e.time}', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 11)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (id) {
                    if (id != null) context.read<FloorViewBloc>().add(FloorViewEventSelected(id));
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Event stats strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _eventStat('TABLES RESERVED', '$reservedInEvent', FocusColors.accent),
                const SizedBox(width: 16),
                _eventStat('TOTAL TABLES', '$totalTables', FocusColors.textPrimary),
                const SizedBox(width: 16),
                _eventStat('AVAILABLE', '${totalTables - reservedInEvent}', FocusColors.success),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _legendDot(FocusColors.success, 'AVAILABLE'),
                const SizedBox(width: 12),
                _legendDot(FocusColors.accent, 'BOOKED FOR EVENT'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Floor tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(state.zoneNames.length, (i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FloorZoneTab(
                    label: state.zoneNames[i],
                    isSelected: state.currentZone == state.zoneNames[i],
                    onTap: () => context.read<FloorViewBloc>().add(FloorViewZoneChanged(state.zoneNames[i])),
                  ),
                )),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Event floor plan — shows reserved-for-event in accent, rest green
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: FocusColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FocusColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cw = constraints.maxWidth;
                  final ch = constraints.maxHeight;
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: SizedBox(
                      width: cw,
                      height: ch,
                      child: Stack(
                        children: [
                          ..._buildAreaLabels(state.currentZone, cw, ch),
                          ...zoneTables.map((table) {
                            final isBookedForEvent = selectedEvent.reservedTableIds.contains(table.id);
                            final eventTable = isBookedForEvent
                                ? table.copyWith(status: TableStatus.reserved)
                                : table.copyWith(status: TableStatus.free);
                            final isCircle = table.tableType == TableType.barStool ||
                                table.tableType == TableType.circle ||
                                table.tableType == TableType.largeCircle;
                            final baseSize = 42.0 * table.sizeMultiplier;
                            final w = isCircle ? baseSize : baseSize * 1.35;
                            final h = isCircle ? baseSize : baseSize * 1.0;
                            final left = table.x * cw - w / 2;
                            final top = table.y * ch - h / 2;
                            return Positioned(
                              left: left.clamp(0, cw - w),
                              top: top.clamp(0, ch - h),
                              child: TableCircleWidget(
                                table: eventTable,
                                isSelected: false,
                                onTap: () => _showEventTableInfo(context, table, isBookedForEvent, selectedEvent.name),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── HELPERS ────────────────────────────────────────────────────
  Widget _modeToggle(BuildContext context, {required bool isEventMode}) {
    return Container(
      decoration: BoxDecoration(
        color: FocusColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FocusColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn(context, label: 'LIVE', active: !isEventMode, onTap: () {
            if (isEventMode) context.read<FloorViewBloc>().add(const FloorViewModeChanged(false));
          }),
          _toggleBtn(context, label: 'EVENT', active: isEventMode, onTap: () {
            if (!isEventMode) context.read<FloorViewBloc>().add(const FloorViewModeChanged(true));
          }),
        ],
      ),
    );
  }

  Widget _toggleBtn(BuildContext context, {required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? FocusColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: active ? Colors.black : FocusColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _eventStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
        Text(value, style: GoogleFonts.inter(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
      ],
    );
  }

  void _onTableTap(BuildContext context, MockTable table) {
    context.read<FloorViewBloc>().add(FloorViewTableSelected(table.id));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TableBottomSheet(
        table: table,
        onMarkFree: () {
          context.read<FloorViewBloc>().add(FloorViewTableStatusChanged(table.id, TableStatus.free));
          Navigator.pop(context);
        },
        onAssignCustomer: (name, phone, guests) {
          context.read<FloorViewBloc>().add(FloorViewTableCustomerAssigned(
            tableId: table.id,
            customerName: name,
            customerPhone: phone,
            guestCount: guests,
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$name assigned to Table ${table.label}'), backgroundColor: FocusColors.success),
          );
        },
        onAssignServer: () => _showAssignServerSheet(context, table.id),
        onMarkNoShow: () {
          context.read<FloorViewBloc>().add(FloorViewTableMarkedNoShow(table.id));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Table marked as No Show — now available'), backgroundColor: FocusColors.error),
          );
        },
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<FloorViewBloc>().add(const FloorViewTableSelected(null));
      }
    });
  }

  void _showEventTableInfo(BuildContext context, MockTable table, bool isBooked, String eventName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FocusColors.elevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: FocusColors.textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('TABLE ${table.label}', style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isBooked ? FocusColors.accent : FocusColors.success).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isBooked ? 'BOOKED' : 'AVAILABLE',
                      style: GoogleFonts.inter(color: isBooked ? FocusColors.accent : FocusColors.success, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Event: $eventName', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 4),
              Text('Capacity: ${table.capacity} guests · ${table.area ?? table.zone}', style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 12)),
              if (isBooked && table.customerName != null) ...[
                const SizedBox(height: 12),
                Text('Reserved for: ${table.customerName}', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignServerSheet(BuildContext context, String tableId) {
    Navigator.pop(context);
    final servers = ['Marcus Chen', 'Elena Rodriguez', 'David Miller', 'Sarah Jenkins'];
    showModalBottomSheet(
      context: context,
      backgroundColor: FocusColors.elevated,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: FocusColors.textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('ASSIGN SERVER', style: GoogleFonts.inter(color: FocusColors.accent, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1)),
              const SizedBox(height: 16),
              ...servers.map((name) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: FocusColors.accent, borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Text(name.split(' ').map((w) => w[0]).join(), style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14)),
                ),
                title: Text(name, style: GoogleFonts.inter(color: FocusColors.textPrimary, fontWeight: FontWeight.w600)),
                subtitle: Text('ACTIVE', style: GoogleFonts.inter(color: FocusColors.success, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                trailing: const Icon(Icons.chevron_right, color: FocusColors.accent),
                onTap: () {
                  context.read<FloorViewBloc>().add(FloorViewTableServerAssigned(tableId: tableId, serverName: name));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name assigned as server'), backgroundColor: FocusColors.success),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAreaLabels(String zone, double cw, double ch) {
    switch (zone) {
      case 'SECOND FLOOR':
        return [
          _areaLabel('MAIN BAR COUNTER', 0.42, 0.01, cw, ch),
          _areaLabel('WEST LOUNGE AREA', 0.10, 0.17, cw, ch),
          _areaLabel('VIP TERRACE', 0.75, 0.17, cw, ch),
          _areaLabel('DJ BOOTH', 0.72, 0.05, cw, ch),
        ];
      case 'FIRST FLOOR':
        return [
          _areaLabel('BAR COUNTER', 0.35, 0.18, cw, ch),
          _areaLabel('MAIN ENTRANCE', 0.78, 0.88, cw, ch),
        ];
      default:
        return [];
    }
  }

  Widget _areaLabel(String text, double x, double y, double cw, double ch) {
    return Positioned(
      left: x * cw - 40,
      top: y * ch,
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: FocusColors.textSecondary.withValues(alpha: 0.5),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.inter(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(color: FocusColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
