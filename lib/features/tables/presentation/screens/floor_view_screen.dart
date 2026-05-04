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
    final zoneTables = state.tables
        .where((t) => t.zone == state.currentZone)
        .toList();
    final allTables = state.tables;
    final freeCount = allTables
        .where((t) => t.status == TableStatus.free)
        .length;
    final reservedCount = allTables
        .where((t) => t.status == TableStatus.reserved)
        .length;
    final occupiedCount = allTables
        .where((t) => t.status == TableStatus.occupied)
        .length;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Mode toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text(
                  'TABLES',
                  style: GoogleFonts.inter(
                    color: FocusColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                _dateFilter(context, state),
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
                children: List.generate(
                  state.zoneNames.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FloorZoneTab(
                      label: state.zoneNames[i],
                      isSelected: state.currentZone == state.zoneNames[i],
                      onTap: () => context.read<FloorViewBloc>().add(
                        FloorViewZoneChanged(state.zoneNames[i]),
                      ),
                    ),
                  ),
                ),
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
                  const tableScale = 0.72;
                  final cw = constraints.maxWidth;
                  final ch = constraints.maxHeight;
                  final virtualW = _floorVirtualWidth(state.currentZone, cw);
                  final controller = _initialViewController(
                    zone: state.currentZone,
                    viewportWidth: cw,
                    virtualWidth: virtualW,
                  );
                  return InteractiveViewer(
                    minScale: 0.55,
                    maxScale: 3.0,
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    transformationController: controller,
                    child: SizedBox(
                      width: virtualW,
                      height: ch,
                      child: Stack(
                        children: [
                          ..._buildAreaLabels(state.currentZone, virtualW, ch),
                          ...zoneTables.map((table) {
                            final isCircle =
                                table.tableType == TableType.barStool ||
                                table.tableType == TableType.circle ||
                                table.tableType == TableType.largeCircle;
                            final baseSize =
                                42.0 * table.sizeMultiplier * tableScale;
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
                _summaryItem(
                  'Total',
                  '${allTables.length}',
                  FocusColors.textPrimary,
                ),
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
        ? state.availableEvents.firstWhere(
            (e) => e.id == state.selectedEventId,
            orElse: () => state.availableEvents.first,
          )
        : state.availableEvents.first;

    final zoneTables = state.tables
        .where((t) => t.zone == state.currentZone)
        .toList();
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
                Text(
                  'TABLES',
                  style: GoogleFonts.inter(
                    color: FocusColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                _dateFilter(context, state),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              selectedEvent.name,
              style: GoogleFonts.inter(
                color: FocusColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Event stats strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _eventStat(
                  'TABLES RESERVED',
                  '$reservedInEvent',
                  FocusColors.accent,
                ),
                const SizedBox(width: 16),
                _eventStat(
                  'TOTAL TABLES',
                  '$totalTables',
                  FocusColors.textPrimary,
                ),
                const SizedBox(width: 16),
                _eventStat(
                  'AVAILABLE',
                  '${totalTables - reservedInEvent}',
                  FocusColors.success,
                ),
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
                children: List.generate(
                  state.zoneNames.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FloorZoneTab(
                      label: state.zoneNames[i],
                      isSelected: state.currentZone == state.zoneNames[i],
                      onTap: () => context.read<FloorViewBloc>().add(
                        FloorViewZoneChanged(state.zoneNames[i]),
                      ),
                    ),
                  ),
                ),
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
                  const tableScale = 0.72;
                  final cw = constraints.maxWidth;
                  final ch = constraints.maxHeight;
                  final virtualW = _floorVirtualWidth(state.currentZone, cw);
                  final controller = _initialViewController(
                    zone: state.currentZone,
                    viewportWidth: cw,
                    virtualWidth: virtualW,
                  );
                  return InteractiveViewer(
                    minScale: 0.55,
                    maxScale: 3.0,
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    transformationController: controller,
                    child: SizedBox(
                      width: virtualW,
                      height: ch,
                      child: Stack(
                        children: [
                          ..._buildAreaLabels(state.currentZone, virtualW, ch),
                          ...zoneTables.map((table) {
                            final isBookedForEvent = selectedEvent
                                .reservedTableIds
                                .contains(table.id);
                            final eventTable = isBookedForEvent
                                ? table.copyWith(status: TableStatus.reserved)
                                : table.copyWith(status: TableStatus.free);
                            final isCircle =
                                table.tableType == TableType.barStool ||
                                table.tableType == TableType.circle ||
                                table.tableType == TableType.largeCircle;
                            final baseSize =
                                42.0 * table.sizeMultiplier * tableScale;
                            final w = isCircle ? baseSize : baseSize * 1.35;
                            final h = isCircle ? baseSize : baseSize * 1.0;
                            final left = table.x * virtualW - w / 2;
                            final top = table.y * ch - h / 2;
                            return Positioned(
                              left: left.clamp(0, virtualW - w),
                              top: top.clamp(0, ch - h),
                              child: TableCircleWidget(
                                table: eventTable,
                                isSelected: false,
                                onTap: () => _showEventTableInfo(
                                  context,
                                  table,
                                  isBookedForEvent,
                                  selectedEvent.name,
                                ),
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
  Widget _dateFilter(BuildContext context, FloorViewLoadSuccess state) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedEvent = state.isEventMode && state.selectedEventId != null
        ? state.availableEvents.firstWhere(
            (e) => e.id == state.selectedEventId,
            orElse: () => state.availableEvents.first,
          )
        : null;
    final selectedDate = selectedEvent?.startsAt ?? today;
    final isLive = _isSameDay(selectedDate, today);

    return GestureDetector(
      onTap: () => _pickDateFilter(context, state),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: FocusColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FocusColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: FocusColors.accent,
              size: 16,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLive ? 'LIVE · TODAY' : _formatDate(selectedDate),
                  style: GoogleFonts.inter(
                    color: FocusColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  isLive
                      ? 'Current day view'
                      : (selectedEvent?.name ?? 'Event day'),
                  style: GoogleFonts.inter(
                    color: FocusColors.textSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              color: FocusColors.accent,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateFilter(
    BuildContext context,
    FloorViewLoadSuccess state,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = state.isEventMode && state.selectedEventId != null
        ? state.availableEvents
              .firstWhere(
                (e) => e.id == state.selectedEventId,
                orElse: () => state.availableEvents.first,
              )
              .startsAt
        : today;
    final initialDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final allowedDates = <DateTime>{
      today,
      ...state.availableEvents.map(
        (e) => DateTime(e.startsAt.year, e.startsAt.month, e.startsAt.day),
      ),
    }.toList()..sort((a, b) => a.compareTo(b));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: allowedDates.first,
      lastDate: allowedDates.last,
      selectableDayPredicate: (date) =>
          allowedDates.any((d) => _isSameDay(d, date)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: FocusColors.accent,
            surface: FocusColors.surface,
            onSurface: FocusColors.textPrimary,
          ),
          dialogTheme: DialogThemeData(backgroundColor: FocusColors.elevated),
        ),
        child: child!,
      ),
    );

    if (picked == null || !context.mounted) return;
    final selectedDay = DateTime(picked.year, picked.month, picked.day);
    if (_isSameDay(selectedDay, today)) {
      context.read<FloorViewBloc>().add(const FloorViewModeChanged(false));
      return;
    }

    final matchingEvents =
        state.availableEvents
            .where((e) => _isSameDay(e.startsAt, selectedDay))
            .toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    if (matchingEvents.isEmpty) return;

    context.read<FloorViewBloc>().add(const FloorViewModeChanged(true));
    context.read<FloorViewBloc>().add(
      FloorViewEventSelected(matchingEvents.first.id),
    );
  }

  Widget _eventStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: FocusColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
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
          context.read<FloorViewBloc>().add(
            FloorViewTableStatusChanged(table.id, TableStatus.free),
          );
          Navigator.pop(context);
        },
        onAssignCustomer: (name, phone, guests) {
          context.read<FloorViewBloc>().add(
            FloorViewTableCustomerAssigned(
              tableId: table.id,
              customerName: name,
              customerPhone: phone,
              guestCount: guests,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name assigned to Table ${table.label}'),
              backgroundColor: FocusColors.success,
            ),
          );
        },
        onAssignServer: () => _showAssignServerSheet(context, table.id),
        onMarkNoShow: () {
          context.read<FloorViewBloc>().add(
            FloorViewTableMarkedNoShow(table.id),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Table marked as No Show — now available'),
              backgroundColor: FocusColors.error,
            ),
          );
        },
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<FloorViewBloc>().add(const FloorViewTableSelected(null));
      }
    });
  }

  void _showEventTableInfo(
    BuildContext context,
    MockTable table,
    bool isBooked,
    String eventName,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FocusColors.elevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FocusColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'TABLE ${table.label}',
                    style: GoogleFonts.inter(
                      color: FocusColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isBooked ? FocusColors.accent : FocusColors.success)
                              .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isBooked ? 'BOOKED' : 'AVAILABLE',
                      style: GoogleFonts.inter(
                        color: isBooked
                            ? FocusColors.accent
                            : FocusColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Event: $eventName',
                style: GoogleFonts.inter(
                  color: FocusColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Capacity: ${table.capacity} guests · ${table.area ?? table.zone}',
                style: GoogleFonts.inter(
                  color: FocusColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              if (isBooked && table.customerName != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Reserved for: ${table.customerName}',
                  style: GoogleFonts.inter(
                    color: FocusColors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
    final servers = [
      'Marcus Chen',
      'Elena Rodriguez',
      'David Miller',
      'Sarah Jenkins',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: FocusColors.elevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FocusColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ASSIGN SERVER',
                style: GoogleFonts.inter(
                  color: FocusColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              ...servers.map(
                (name) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: FocusColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      name.split(' ').map((w) => w[0]).join(),
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: GoogleFonts.inter(
                      color: FocusColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'ACTIVE',
                    style: GoogleFonts.inter(
                      color: FocusColors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: FocusColors.accent,
                  ),
                  onTap: () {
                    context.read<FloorViewBloc>().add(
                      FloorViewTableServerAssigned(
                        tableId: tableId,
                        serverName: name,
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$name assigned as server'),
                        backgroundColor: FocusColors.success,
                      ),
                    );
                  },
                ),
              ),
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
          _areaLabel('VIP TERRACE', 0.96, 0.47, cw, ch),
          _areaLabel('DJ BOOTH', 0.72, 0.05, cw, ch),
          _areaLabel('202A', 0.905, 0.30, cw, ch),
          _areaLabel('201A', 0.905, 0.81, cw, ch),
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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  double _floorVirtualWidth(String zone, double screenWidth) {
    if (zone == 'SECOND FLOOR') return screenWidth * 2.1;
    return screenWidth;
  }

  TransformationController _initialViewController({
    required String zone,
    required double viewportWidth,
    required double virtualWidth,
  }) {
    final scale = zone == 'SECOND FLOOR'
        ? ((viewportWidth / virtualWidth) * 0.94).clamp(0.55, 1.0)
        : 1.0;
    return TransformationController(Matrix4.diagonal3Values(scale, scale, 1.0));
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
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: FocusColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            color: FocusColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
