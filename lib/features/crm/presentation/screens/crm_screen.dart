import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/design_constants.dart';
import '../../../../shared/widgets/avatar_widget.dart';
import '../../../../shared/widgets/search_bar_widget.dart';
import '../../../../shared/widgets/pagination_widget.dart';
import '../../data/mock_customers.dart';
import '../../bloc/crm_bloc.dart';
import '../../bloc/crm_event.dart';
import '../../bloc/crm_state.dart';

const _filters = ['ALL', 'VIP', 'RETURNING', 'NEW', 'NO SHOW'];

class CrmScreen extends StatelessWidget {
  const CrmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrmBloc, CrmState>(
      builder: (context, state) {
        if (state is! CrmLoadSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        final totalCustomers = state.customers.length;
        final totalRevenue = state.customers.fold<double>(
          0,
          (sum, c) => sum + c.totalSpend,
        );
        final averageSpend = totalCustomers == 0
            ? 0.0
            : totalRevenue / totalCustomers;
        final vipCustomers = state.customers
            .where((c) => c.tier == 'VIP GOLD' || c.tier == 'PLATINUM')
            .length;
        final topComers = [...state.customers]
          ..sort((a, b) => b.totalVisits.compareTo(a.totalVisits));
        final topSpenders = [...state.customers]
          ..sort((a, b) => b.totalSpend.compareTo(a.totalSpend));
        final items = state.filtered;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CRM',
                      style: GoogleFonts.inter(
                        color: FocusColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customer dashboard, retention and spending insights',
                      style: GoogleFonts.inter(
                        color: FocusColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 86,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _MetricCard(
                      label: 'CUSTOMERS',
                      value: '$totalCustomers',
                      color: FocusColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    _MetricCard(
                      label: 'TOTAL SPEND',
                      value: '\$${totalRevenue.toStringAsFixed(0)}',
                      color: FocusColors.success,
                    ),
                    const SizedBox(width: 8),
                    _MetricCard(
                      label: 'AVG SPEND',
                      value: '\$${averageSpend.toStringAsFixed(0)}',
                      color: FocusColors.info,
                    ),
                    const SizedBox(width: 8),
                    _MetricCard(
                      label: 'VIP / PLATINUM',
                      value: '$vipCustomers',
                      color: FocusColors.accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchBarWidget(
                  hint: 'Search profiles...',
                  onChanged: (v) =>
                      context.read<CrmBloc>().add(CrmSearchChanged(v)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final f = _filters[i];
                    final active = f == state.filter;
                    return GestureDetector(
                      onTap: () =>
                          context.read<CrmBloc>().add(CrmFilterChanged(f)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: active
                              ? FocusColors.accent
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: active
                              ? null
                              : Border.all(color: FocusColors.border),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          f,
                          style: GoogleFonts.inter(
                            color: active
                                ? Colors.black
                                : FocusColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'TOP COMERS',
                  style: GoogleFonts.inter(
                    color: FocusColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: topComers.length > 5 ? 5 : topComers.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => _TopCustomerCard(
                    customer: topComers[i],
                    metric: '${topComers[i].totalVisits} visits',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'TOP SPENDERS',
                  style: GoogleFonts.inter(
                    color: FocusColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: topSpenders.length > 5 ? 5 : topSpenders.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => _TopCustomerCard(
                    customer: topSpenders[i],
                    metric: '\$${topSpenders[i].totalSpend.toStringAsFixed(0)}',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No customers found',
                          style: GoogleFonts.inter(
                            color: FocusColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final c = items[i];
                          return InkWell(
                            onTap: () => context.go('/crm/${c.id}'),
                            splashColor: FocusColors.elevated,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: FocusColors.border,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  AvatarWidget(name: c.name, size: 40),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              c.name,
                                              style: GoogleFonts.inter(
                                                color: FocusColors.textPrimary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _tierColor(
                                                  c.tier,
                                                ).withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                c.tier,
                                                style: GoogleFonts.inter(
                                                  color: _tierColor(c.tier),
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${c.phone}  ·  ${c.totalVisits} visits  ·  \$${c.totalSpend.toStringAsFixed(0)}',
                                          style: GoogleFonts.inter(
                                            color: FocusColors.textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: FocusColors.textSecondary,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              PaginationWidget(
                currentPage: 1,
                totalPages: 2,
                onPageChanged: (_) {},
              ),
            ],
          ),
        );
      },
    );
  }
}

Color _tierColor(String tier) {
  if (tier.contains('PLATINUM')) return FocusColors.accent;
  if (tier.contains('VIP')) return FocusColors.accent;
  if (tier == 'MEMBER') return FocusColors.info;
  return FocusColors.textSecondary;
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Column(
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
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCustomerCard extends StatelessWidget {
  final MockCustomer customer;
  final String metric;

  const _TopCustomerCard({required this.customer, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 176,
      padding: const EdgeInsets.all(10),
      decoration: cardDecoration(),
      child: Row(
        children: [
          AvatarWidget(name: customer.name, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: FocusColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metric,
                  style: GoogleFonts.inter(
                    color: FocusColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
