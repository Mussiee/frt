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

        final tables = state.tables;
        final freeCount = tables.where((t) => t.status == TableStatus.free).length;
        final reservedCount = tables.where((t) => t.status == TableStatus.reserved).length;
        final occupiedCount = tables.where((t) => t.status == TableStatus.occupied).length;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    Text(
                      'Live Floor Layout',
                      style: GoogleFonts.inter(color: FocusColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    _legendDot(FocusColors.success, 'FREE'),
                    const SizedBox(width: 12),
                    _legendDot(FocusColors.accent, 'RESERVED'),
                    const SizedBox(width: 12),
                    _legendDot(FocusColors.error, 'OCCUPIED'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
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
                              ...tables.map((table) {
                                final tableWidget = TableCircleWidget(
                                  table: table,
                                  isSelected: state.selectedTableId == table.id,
                                  onTap: () => _onTableTap(context, table),
                                );
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
                                  child: tableWidget,
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
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: cardDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryItem('Total', '${tables.length}', FocusColors.textPrimary),
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
      },
    );
  }

  List<Widget> _buildAreaLabels(String zone, double cw, double ch) {
    switch (zone) {
      case 'SECOND FLOOR':
        return [
          _areaLabel('MAIN BAR COUNTER', 0.42, 0.01, cw, ch),
          _areaLabel('WEST LOUNGE AREA', 0.10, 0.17, cw, ch),
          _areaLabel('VIP TERRACE', 0.85, 0.17, cw, ch),
          _areaLabel('DJ BOOTH', 0.78, 0.05, cw, ch),
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

  void _onTableTap(BuildContext context, MockTable table) {
    context.read<FloorViewBloc>().add(FloorViewTableSelected(table.id));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TableBottomSheet(
        table: table,
        onMarkFree: () => Navigator.pop(context),
        onAssignCustomer: () => Navigator.pop(context),
        onAssignServer: () => _showAssignServerSheet(context),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<FloorViewBloc>().add(const FloorViewTableSelected(null));
      }
    });
  }

  void _showAssignServerSheet(BuildContext context) {
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
                onTap: () => Navigator.pop(context),
              )),
            ],
          ),
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
